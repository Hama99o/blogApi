require 'rails_helper'

describe Api::V1::ArticlesController, type: :request do
  describe 'GET /articles' do
    subject { get path , params: params}
    let(:articles) { create_list(:article, nb_articles) }
    let(:nb_articles) { 25 }
    let(:user) { create_user }
    let(:params) { {} }
    let(:path) {'/api/v1/articles'}
    let(:headers) {{ 'Authorization': response.headers['Authorization'] }}

    before do
      login_with_api(user)
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user' do
      expect(json['data']).to have_id(user.id.to_s)
      expect(json['data']).to have_type('users')
    end

    context 'with articles' do
      let(:nb_articles) { 5 }

      before do
        login_with_api(user)

        articles
      end

      it 'return all articles' do
        subject
        expect(response).to have_http_status(200)
        expect(json['articles'].count).to eq(5)
        expect(json['articles'].count).not_to eq(6)
      end
    end

    context 'with search attributes' do
      let(:article) { create(:article, title: 'Test project') }
      let(:params) { { search: 'rojec' } }

      before do
        article
      end

      it 'finds a searched article by title' do
        subject
        body = JSON.parse(response.body)
        id = body['articles'].first['id']
        expect(id).to eq(article.id)
      end
    end

    context 'with search and paginate attributes' do
      let(:article) { create(:article, title: 'Test articles') }
      let(:params) { { page: 0, per: 30, search: 'art' } }

      before do
        article
        articles
      end

      it 'finds a searched and paginate article by title and content' do
        subject
        id = json['articles'].first['id']
        per = json['meta']['per']
        expect(id).to eq(article.id)
        expect(json['articles'].count).to eq(1)
        expect(per).to eq(30)
      end
    end

    context 'with pagination' do
      let(:params) {{ page: 0 }}

      before do
        articles
      end

      it 'has first page of articles per 15' do
        subject
        body = JSON.parse(response.body)
        expect(body['articles'].count).to eq(15)
      end
    end

    context 'with pagination' do
      let(:params) {{ page: 1 }}

      before do
        articles
      end

      it 'has the second page of articles' do
        subject
        body = JSON.parse(response.body)
        expect(body['articles'].count).to eq(10)
      end
    end

    describe 'destroy/articles' do
      let!(:article) { create(:article) }
      subject { delete "/api/v1/articles/#{article.id}", headers: headers }

      it 'removes article' do
        expect do
          subject
        end.to change(Article, :count).by(-1)
        expect(response).to be_successful
      end
    end

    describe 'POST/articles' do
      let(:params) do
        {
          article: {
            title: 'hi world',
            content: 'hi_world'
          }
        }
      end
      subject do
        post "/api/v1/articles", params: params, headers: headers
      end

      it 'create a new article' do
        expect do
          subject
        end.to change(Article, :count).by(1)
        expect(response).to have_http_status(:created)
        expect(response.status).not_to eq 422
      end
    end

    describe 'PUT and PATCH/articles' do
      let(:article_to_update) { create(:article, title: 'hi world', content: 'hi_world') }
      let(:article_params) do
        {
          title: 'hello world',
          content: 'hello_world',
          tags: ['js']
        }
      end

      subject do
        put "/api/v1/articles/#{article_to_update.id}", params: { id: article_to_update, article: article_params }, headers: headers
      end

      it 'updates a certain articles' do
        expect do
          subject
        end.to change { article_to_update.reload.title }.to('hello world')
                                                        .and change {
                                                               article_to_update.reload.content
                                                             }.to('hello_world')
        expect(response.status).to eq 200
        expect(article_to_update.reload.content).not_to eq('hi_world')
        expect(article_to_update.reload.tags).not_to eq(['js'])
      end
    end
  end
end
