require 'rails_helper'

describe OperationsController, :type => :controller do

  shared_context 'is logged in' do
    before do
      sign_in  create :user, role: role
    end
  end

  shared_examples 'not logged in' do
    it { is_expected.to redirect_to new_user_session_path }
  end

  shared_examples 'index action not authorized' do
    it 'must not be possible list operations' do
      expect{ subject }.to change{ assigns(:operations) }.to([])
    end

    it_behaves_like 'must be redirect'
  end

  shared_examples 'must be redirect' do
    it 'must be redirect' do
      expect(subject).to redirect_to root_path
    end
  end

  describe 'GET #index' do
    context 'when authenticated' do
      include_context 'is logged in'

      subject { get :index }

      let!(:operation) { create :operation }

      context 'as admin' do
        let(:role){ :admin }

        it { is_expected.to be_success }

        it 'assigns the operation to @operations' do
          expect{ subject }.to change{ assigns(:operations) }.to([operation])
        end

        it 'renders the index template' do
          expect(subject).to render_template(:index)
        end
      end

      context 'as customer' do
        let(:role){ :customer }

        it_behaves_like 'index action not authorized'
      end

      context 'as agent' do
        let(:role){ :agent }

        it_behaves_like 'index action not authorized'
      end
    end

    context 'when not authenticated' do
      subject { get :index }

      it_behaves_like 'not logged in'
    end
  end

  describe 'GET #show' do
    let(:operation) { create :operation }

    subject { get :show, id: operation.id }

    context 'when authenticated' do
      include_context 'is logged in'

      context 'as admin' do
        let(:role){ :admin }

        it { is_expected.to be_success }

        it 'assigns the requested operation to @operation' do
          expect{ subject }.to change{ assigns(:operation) }.to(operation)
        end

        it 'render the correct view' do
          expect(subject).to render_template :show
        end
      end

      context 'as customer' do
        let(:role){ :customer }

        it_behaves_like 'must be redirect'
      end

      context 'as agent' do
        let(:role){ :agent }

        it_behaves_like 'must be redirect'
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

      context 'as admin' do
        let(:role){ :admin }

        it 'renders the #new template' do
          expect(subject).to render_template(:new)
        end
      end

      context 'as customer' do
        let(:role){ :customer }

        it_behaves_like 'must be redirect'
      end

      context 'as agent' do
        let(:role){ :agent }

        it_behaves_like 'must be redirect'
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

      subject { post :create, operation: attributes_for(:operation) }

      context 'as admin' do
        let(:role) { :admin }

        context 'with a valid attributes' do

          it 'creates a new operation' do
            expect {
              subject
            }.to change(Operation, :count).by(1)
          end

          it 'redirects to the new operation' do
            expect(subject).to redirect_to operation_path(Operation.last)
          end
        end

        context 'with invalid attributes' do
          subject { post :create, operation: attributes_for(:invalid_operation) }

          it 'does not save the new operation' do
            expect {
              subject
            }.to_not change(Operation, :count)
          end

          it 're-renders the new method' do
            expect(subject).to render_template :new
          end
        end
      end

      context 'as customer' do
        let(:role) { :customer }

        it_behaves_like 'must be redirect'
      end

      context 'as agent' do
        let(:role) { :agent }

        it_behaves_like 'must be redirect'
      end
    end

    context 'when not authenticated' do
      subject { post :create, operation: attributes_for(:operation) }

      it_behaves_like 'not logged in'
    end
  end

  describe 'PUT #update' do
    context 'when authenticated' do
      include_context 'is logged in'

      let(:operation){ create :operation }

      subject { put :update, id: operation, operation: attributes_for(:operation)  }

      context 'as admin' do
        let(:role) { :admin }

        context 'valid attributes' do
          it 'located the requested @operation' do
            subject

            expect(assigns(:operation)).to eq(operation)
          end

          it 'changes @operation attributes' do
            put :update, id: operation, operation: attributes_for(:operation, name: 'New Name')
            operation.reload

            expect(operation.name).to eq('New Name')
          end

          it 'redirects to the updated operation' do
            expect(subject).to redirect_to operation_path(operation)
          end
        end

        context 'invalid attributes' do
          it 'locates the requested @operation' do
            put :update, id: operation, operation: attributes_for(:invalid_operation)
            expect(assigns(:operation)).to eq(operation)
          end

          it 're-renders the edit method' do
            put :update, id: operation, operation: attributes_for(:invalid_operation)
            expect(response).to render_template :edit
          end
        end
      end

      context 'as customer' do
        let(:role) { :customer }

        it_behaves_like 'must be redirect'
      end

      context 'as agent' do
        let(:role) { :agent }

        it_behaves_like 'must be redirect'
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

      let!(:operation){ create :operation }

      subject { delete :destroy, id: operation }

      context 'as admin' do
        let(:role) { :admin }

        it 'deletes the operation' do
          expect{
            subject
          }.to change(Operation,:count).by(-1)
        end

        it 'redirects to houses#index' do
          expect(subject).to redirect_to operations_path
        end
      end

      context 'as customer' do
        let(:role) { :customer }

        it_behaves_like 'must be redirect'
      end

      context 'as agent' do
        let(:role) { :agent }

        it_behaves_like 'must be redirect'
      end
    end

    context 'when not authenticated' do
      subject { post :create, house: attributes_for(:invalid_house) }

      it_behaves_like 'not logged in'
    end
  end
end
