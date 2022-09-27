require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  let(:user) { create(:user) }

  before { sign_in user }

  describe '#index' do
    let(:owned_lists) { create_list(:list, 5, user: user) }
    let(:shared_lists) { create_list(:list, 2, affiliated_users: [user])}

    subject { get :index }

    it "renders template index" do
      expect(subject).to render_template(:index)
    end

    it 'asigns users lists' do
      subject
      expect(assigns(:lists)).to eq owned_lists
    end

    it 'asigns shared users lists' do
      subject
      expect(assigns(:shared_lists)).to eq shared_lists
    end
  end

  describe '#show' do
    let(:list) { create(:list, user: user) }
    let!(:items) do
      [create(:item, list: list), create(:item, :completed, list: list)]
    end

    subject { get :show, params: { id: list.id } }

    it "renders show template" do
      expect(subject).to render_template :show
    end

    it 'assigns correct list' do
      subject
      expect(assigns(:list)).to eq list
    end

    it 'assigns correct list' do
      subject
      expect(assigns(:items)).to eq items.to_a.sort_by { |entity| entity.completed.to_s }
    end

    context 'when user tries to see the list he does not belong to' do
      let(:list) { create(:list) }

      it "raises exception" do
        expect { subject }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'when users tries to open shared list' do
      let(:list) { create(:list, affiliated_users: [user]) }

      it "renders show template" do
        expect(subject).to render_template :show
      end

      it 'assigns correct list' do
        subject
        expect(assigns(:list)).to eq list
      end

      it 'assigns correct list' do
        subject
        expect(assigns(:items)).to eq items.to_a.sort_by { |entity| entity.completed.to_s }
      end
    end
  end

  describe '#new' do
    subject { get :new }

    it { is_expected.to render_template :new }

    it 'assigns a new list' do
      subject
      expect(assigns(:list)).to be_a_new(List)
    end
  end

  describe "#create" do
    subject { process :create, method: :post, params: params }

    let(:params) { { list: attributes_for(:list) } }

    it 'creates a list' do
      expect { subject }.to change(List, :count).by(1)
    end

    it 'redirects to post page' do
      subject
      expect(response).to redirect_to list_url(List.last)
    end

    it 'assigns post to current user' do
      subject
      expect(assigns(:list).user).to eq user
    end

    context 'when list params are invalid' do
      let(:params) { { list: { title: nil, body: 'Some body' } } }

      it { is_expected.to render_template(:new) }

      it 'assigns record with errors' do
        subject

        expect(assigns(:list).errors).to_not be_empty
      end
    end
  end

  describe '#edit' do
    let(:list) { create(:list, user: user) }

    subject { get :edit, params: { id: list.id } }

    it { is_expected.to render_template :edit }

    it 'assigns a new list' do
      subject
      expect(assigns(:list)).to eq(list)
    end

    context 'when user tries to edit lists that he does not own' do
      let(:list) { create(:list) }

      it 'returns exception' do
        expect { subject }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#update" do
    subject { process :update, method: :patch, params: params }

    let!(:list) { create(:list, title: 'Hey student', user: user) }

    let(:params) { { id: list.id, list: attributes_for(:list, title: 'Hey CDG') } }

    it 'updates a list' do
      expect { subject }.to change { list.reload.title }.from('Hey student').to('Hey CDG')
    end

    it 'redirects to post page' do
      subject
      expect(response).to redirect_to list_url(List.last)
    end

    context 'when list params are invalid' do
      let(:params) { { id: list.id, list: { title: nil, body: 'Some body' } } }

      it { is_expected.to render_template(:edit) }

      it 'assigns record with errors' do
        subject

        expect(assigns(:list).errors).to_not be_empty
      end
    end
  end

  describe '#destroy' do
    let!(:list) { create(:list, user: user) }

    subject { process :destroy, method: :delete, params: { id: list.id } }

    it { is_expected.to redirect_to(:lists) }

    it 'deletes object from DB' do
      expect { subject }.to change(List, :count).by(-1)
    end

    context 'when user tries to remove someones post' do
      let(:list) { create :list }

      it 'redirects to posts index' do
        expect { subject }.to raise_exception(ActiveRecord::RecordNotFound).and(
          change(user.lists, :count).by(0)
        )
      end
    end
  end
end
