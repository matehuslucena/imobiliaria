require 'rails_helper'

describe CustomersController, :type => :controller do

  shared_context 'is logged in' do
    before(:each) do
      sign_in create :user
    end
  end

  shared_examples 'not logged in' do
    it { is_expected.to redirect_to new_user_session_path }
  end

  describe 'GET #index' do
    let(:customer) { create :customer }

    context 'when user is logged in' do
      subject { get :index }

      include_context 'is logged in'

      context 'when param is valid' do
        it { is_expected.to be_success }

        it 'assigns the requested customer to @customer' do
          expect{ subject }.to change{ assigns(:customers) }.to([customer])
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
    let(:customer) { create :customer }
    subject { get :show, id: customer }

    context 'when user is logged in' do
      include_context 'is logged in'

      it { is_expected.to be_success }

      it 'assigns the requested customer to @customer' do
        expect{ subject }.to change{ assigns(:customer) }.to(customer)
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
    let(:customer) { create :customer }
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
        it 'creates a new customer' do
          expect {
            post :create, customer: attributes_for(:customer)
          }.to change(Customer, :count).by(1)
        end

        it 'redirects to the new customer' do
          post :create, customer: attributes_for(:customer)

          expect(response).to redirect_to customer_path(Customer.last)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new customer' do
          expect {
            post :create, customer: attributes_for(:invalid_customer)
          }.to_not change(Customer, :count)
        end

        it 're-renders the new method' do
          post :create, customer: attributes_for(:invalid_customer)

          expect(response).to render_template :new
        end
      end
    end

    context 'when user is not logged' do
      subject { post :create, customer: attributes_for(:invalid_customer) }

      it_behaves_like 'not logged in'
    end
  end

  describe 'PUT #update' do
    context 'when user is logged in' do
      let(:customer){ create :customer }

      include_context 'is logged in'

      context 'valid attributes' do

        it 'located the requested @customer' do
          put :update, id: customer, customer: attributes_for(:customer)

          expect(assigns(:customer)).to eq(customer)
        end

        it 'changes @customer attributes' do
          put :update, id: customer, customer: attributes_for(:customer, first_name: 'First Name')
          customer.reload

          expect(customer.first_name).to eq('First Name')
        end

        it 'redirects to the updated customer' do
          put :update, id: customer, customer: attributes_for(:customer)

          expect(response).to redirect_to customer_path(customer)
        end
      end

      context 'invalid attributes' do
        it 'locates the requested @customer' do
          put :update, id: customer, customer: attributes_for(:invalid_customer)
          expect(assigns(:customer)).to eq(customer)
        end

        it 'does not change @customer attributes' do
          put :update, id: customer, customer: attributes_for(:customer, first_name: nil, address: 'New Address')
          customer.reload

          expect(customer.address).not_to eq('New Address')
        end

        it 're-renders the edit method' do
          put :update, id: customer, customer: attributes_for(:invalid_customer)
          expect(response).to render_template :edit
        end
      end
    end

    context 'when user is not logged' do
      subject { post :create, customer: attributes_for(:customer) }

      it_behaves_like 'not logged in'
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is logged in' do
      let!(:customer){ create :customer }

      include_context 'is logged in'

      it 'deletes the customer' do
        expect{
          delete :destroy, id: customer
        }.to change(Customer,:count).by(-1)
      end

      it 'redirects to customers#index' do
        delete :destroy, id: customer
        expect(response).to redirect_to customers_path
      end
    end

    context 'when user is not logged' do
      subject { post :create, customer: attributes_for(:invalid_customer) }

      it_behaves_like 'not logged in'
    end
  end
end
