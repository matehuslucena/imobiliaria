require 'rails_helper'

describe HousesController, :type => :controller do

  shared_context 'is logged in' do
    before(:each) do
      sign_in create :user
    end
  end

  shared_examples 'not logged in' do
    it { is_expected.to redirect_to new_user_session_path }
  end

  describe 'GET #index' do
    let(:house) { create :house }

    context 'when user is logged in' do
      subject { get :index }

      include_context 'is logged in'

      context 'when param is valid' do
        it { is_expected.to be_success }

        it 'assigns the requested house to @house' do
          expect{ subject }.to change{ assigns(:houses) }.to([house])
        end

        it 'renders the index template' do
          expect(subject).to render_template(:index)
        end
      end
    end

    context 'when user is not logged' do
      subject { get :index }

      it_behaves_like 'not logged in'
    end
  end

  describe 'GET #show' do
    let(:house) { create :house }
    subject { get :show, id: house.id }

    context 'when user is logged in' do
      include_context 'is logged in'

      it { is_expected.to be_success }

      it 'assigns the requested house to @house' do
        expect{ subject }.to change{ assigns(:house) }.to(house)
      end

      it 'render the correct view' do
        expect(subject).to render_template :show
      end
    end

    context 'when user is not logged' do
      subject { get :show, id: 1 }

      it_behaves_like 'not logged in'
    end
  end

  describe 'GET #new' do
    let(:house) { create :house }
    subject { get :new }

    context 'when user ig logged in' do
      include_context 'is logged in'

      it 'renders the #new template' do
        expect(subject).to render_template(:new)
      end
    end

    context 'when user is not logged' do
      subject { get :new }

      it_behaves_like 'not logged in'
    end
  end

  describe 'POST #create' do
    context 'when user is logged in' do

      include_context 'is logged in'

      context 'with valid attributes' do
        it 'creates a new house' do
          expect {
            post :create, house: attributes_for(:house)
          }.to change(House, :count).by(1)
        end

        it 'redirects to the new house' do
          post :create, house: attributes_for(:house)

          expect(response).to redirect_to house_path(House.last)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new house' do
          expect {
            post :create, house: attributes_for(:invalid_house)
          }.to_not change(House, :count)
        end

        it 're-renders the new method' do
          post :create, house: attributes_for(:invalid_house)

          expect(response).to render_template :new
        end
      end
    end

    context 'when user is not logged' do
      subject { post :create, house: attributes_for(:invalid_house) }

      it_behaves_like 'not logged in'
    end
  end

  describe 'PUT #update' do
    context 'when user is logged in' do
      let(:house){ create :house }

      include_context 'is logged in'

      context 'valid attributes' do

        it 'located the requested @house' do
          put :update, id: house, house: attributes_for(:house)

          expect(assigns(:house)).to eq(house)
        end

        it 'changes @house attributes' do
          put :update, id: house, house: attributes_for(:house, address: 'New Address')
          house.reload

          expect(house.address).to eq('New Address')
        end

        it 'redirects to the updated house' do
          put :update, id: house, house: attributes_for(:house)

          expect(response).to redirect_to house_path(house)
        end
      end

      context 'invalid attributes' do
        it 'locates the requested @house' do
          put :update, id: house, house: attributes_for(:invalid_house)
          expect(assigns(:house)).to eq(house)
        end

        it 'does not change @house attributes' do
          put :update, id: house, house: attributes_for(:house, address: nil, city: 'New City')
          house.reload

          expect(house.city).not_to eq('New City')
        end

        it 're-renders the edit method' do
          put :update, id: house, house: attributes_for(:invalid_house)
          expect(response).to render_template :edit
        end
      end
    end

    context 'when user is not logged' do
      subject { post :create, house: attributes_for(:invalid_house) }

      it_behaves_like 'not logged in'
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      let!(:house){ create :house }

      include_context 'is logged in'

      it 'deletes the house' do
        expect{
          delete :destroy, id: house
        }.to change(House,:count).by(-1)
      end

      it 'redirects to houses#index' do
        delete :destroy, id: house
        expect(response).to redirect_to houses_path
      end
    end

    context 'when user is not logged' do
      subject { post :create, house: attributes_for(:invalid_house) }

      it_behaves_like 'not logged in'
    end
  end
end
