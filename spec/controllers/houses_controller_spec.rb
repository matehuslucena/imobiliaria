require 'rails_helper'

describe HousesController, :type => :controller do

  shared_context 'is logged in' do
    before do
      sign_in  create :user, role: role
    end
  end

  shared_examples 'not logged in' do
    it { is_expected.to redirect_to new_user_session_path }
  end

  shared_examples 'authorize list all houses' do
    it { expect{ subject }.to change{ assigns(:houses) }.to([house, another_house]) }
  end

  shared_examples 'when show is authorized' do
    it { is_expected.to be_success }

    it 'assigns the requested house to @house' do
      expect{ subject }.to change{ assigns(:house) }.to(house)
    end

    it 'render the correct view' do
      expect(subject).to render_template :show
    end
  end

  shared_examples 'when new is authorized' do
    it 'renders the #new template' do
      expect(subject).to render_template(:new)
    end
  end

  shared_examples 'when create is authorized' do
    let!(:operation) { create :operation }
    let(:customer) { create :user, email: 't@t.com', role: :customer }

    it 'creates a new house choosing customer_id' do
      expect {
        post :create, house: attributes_for(:house).merge({operation_id: operation.id, user_id: customer })
      }.to change(House, :count).by(1)
    end
  end

  describe 'GET #index' do
    context 'when authenticated' do
      include_context 'is logged in'

      subject { get :index }

      let!(:house) { create :house, user: controller.current_user }
      let(:another_user) { create :user, email: 't@t.com' }
      let(:another_house) { create :house, user: another_user }

      context 'as customer' do
        let(:role){ :customer }

        it { is_expected.to be_success }

        it 'assigns the houses of other customers to @houses' do
          expect{ subject }.to change{ assigns(:houses) }.to([another_house])
        end

        it 'renders the index template' do
          expect(subject).to render_template(:index)
        end
      end

      context 'as admin' do
        let(:role){ :admin }

        it_behaves_like 'authorize list all houses'
      end

      context 'as agent' do
        let(:role){ :agent }

        it_behaves_like 'authorize list all houses'
      end
    end

    context 'when not authenticated' do
      subject { get :index }

      it_behaves_like 'not logged in'
    end
  end

  describe 'GET #show' do
    let(:house) { create :house, user: controller.current_user }
    let(:another_user) { create :user, email: 't@t.com' }
    let(:another_house) { create :house, user: another_user}

    subject { get :show, id: house.id }

    context 'when authenticated' do
      include_context 'is logged in'

      context 'as customer' do
        let(:role){ :customer }

        it_behaves_like 'when show is authorized'
      end

      context 'as admin' do
        let(:role){ :admin }

        it_behaves_like 'when show is authorized'
      end

      context 'as agent' do
        let(:role){ :agent }

        it_behaves_like 'when show is authorized'
      end
    end

    context 'when not authenticated' do
      subject { get :show, id: 1 }

      it_behaves_like 'not logged in'
    end
  end

  describe 'GET #new' do
    context 'when authenticated' do
      include_context 'is logged in'

      subject { get :new }

      context 'as customer' do
        let(:role){ :customer }

        it_behaves_like 'when new is authorized'
      end

      context 'as admin' do
        let(:role){ :admin }

        it_behaves_like 'when new is authorized'
      end

      context 'as agent' do
        let(:role){ :agent }

        it_behaves_like 'when new is authorized'
      end
    end

    context 'when not authenticated' do
      subject { get :show, id: 1 }

      it_behaves_like 'not logged in'
    end
  end

  describe 'POST #create' do
    context 'when authenticated' do
      include_context 'is logged in'

      context 'as customer' do
        let(:role) { :customer }
        let!(:operation) { create :operation }

        it 'creates a new house' do
          expect {
            post :create, house: attributes_for(:house).merge({operation_id: operation.id })
          }.to change(House, :count).by(1)
        end

        it 'redirects to the new house' do
          post :create, house: attributes_for(:house).merge({operation_id: operation.id })

          expect(response).to redirect_to house_path(House.last)
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

      context 'as admin' do
        let(:role) { :admin }

        it_behaves_like 'when create is authorized'
      end

      context 'as agent' do
        let(:role) { :agent }

        it_behaves_like 'when create is authorized'
      end
    end

    context 'when not authenticated' do
      subject { post :create, house: attributes_for(:invalid_house) }

      it_behaves_like 'not logged in'
    end
  end

  describe 'PUT #update' do
    context 'when authenticated' do
      include_context 'is logged in'

      context 'as customer' do
        let(:role) { :customer }
        let(:house){ create :house, user: controller.current_user }

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

      context 'as agent' do
        let(:role) { :agent }
        let(:house){ create :house, user: controller.current_user }

        context 'valid attributes' do
          it 'located the requested @house' do
            put :update, id: house, house: attributes_for(:house)

            expect(assigns(:house)).to eq(house)
          end

          it 'changes @house attributes' do
            old_address = house.address
            put :update, id: house, house: attributes_for(:house, address: 'New Address')
            house.reload

            expect(house.address).to eq(old_address)
          end

          it 'redirects to the updated house' do
            put :update, id: house, house: attributes_for(:house)

            expect(response).to redirect_to root_path
          end
        end
      end
    end

    context 'when not authenticated' do
      subject { post :create, house: attributes_for(:invalid_house) }

      it_behaves_like 'not logged in'
    end
  end

  describe 'DELETE #destroy' do
    context 'when authenticated' do
      include_context 'is logged in'
      let!(:house){ create :house, user: controller.current_user }

      context 'as customer' do
        let(:role) { :customer }

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

      context 'as agent' do
        let(:role) { :agent }

        it 'deletes the house' do
          expect{
            delete :destroy, id: house
          }.to change(House,:count).by(0)
        end

        it 'redirects to houses#index' do
          delete :destroy, id: house
          expect(response).to redirect_to root_path
        end
      end
    end

    context 'when not authenticated' do
      subject { post :create, house: attributes_for(:invalid_house) }

      it_behaves_like 'not logged in'
    end
  end
end
