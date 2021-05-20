require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :controller do
  describe 'GET /articles' do
    let(:articles) { create_list(:article, nb_articles) }
    let(:nb_articles) { 25 }

    context 'with articles' do
      let(:nb_articles) { 5 }

      before do
        articles
      end

      subject { get :index }

      it 'return all articles' do
        subject
        body = JSON.parse(response.body)
        expect(response).to have_http_status(:success)
        expect(body['articles'].count).to eq(5)
        expect(body['articles'].count).not_to eq(6)
      end
    end

    context 'with search attributes' do
      let(:article) { create(:article, title: 'Test project') }
      let(:search) { 'rojec' }

      before do
        article
      end

      subject { get :index, params: { search: search } }

      it 'finds a searched article by title' do
        subject
        body = JSON.parse(response.body)
        id = body['articles'].first['id']
        expect(id).to eq(article.id)
      end
    end

    context 'with search and paginate attributes' do
      let(:article) { create(:article, title: 'Test articles') }
      let(:search) { 'art' }

      before do
        article
        articles
      end

      subject { get :index, params: { page: 0, per: 30, search: search } }

      it 'finds a searched and paginate article by title and content' do
        subject
        body = JSON.parse(response.body)
        id = body['articles'].first['id']
        per = body['meta']['per']
        expect(id).to eq(article.id)
        expect(body['articles'].count).to eq(1)
        expect(per).to eq(30)
      end
    end

    context 'with pagination' do
      subject { get :index, params: { page: 0 } }

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
      subject { get :index, params: { page: 1 } }

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

      subject { delete :destroy, params: { id: article.id } }
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
            content: 'hi_world',
            categories: 'good',
            language: 'rb'
          }
        }
      end
      subject { post :create, params: params }

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
          language: 'main'
        }
      end

      subject do
        put :update, params: { id: article_to_update, article: article_params }
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
      end
    end
  end
end
