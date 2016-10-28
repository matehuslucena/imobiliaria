require 'rails_helper'

describe ReservationsController, :type => :controller do

  shared_context 'is logged in' do
    before do
      sign_in  create :user, role: role
    end
  end

  shared_examples 'not logged in' do
    it { is_expected.to redirect_to new_user_session_path }
  end

  shared_examples 'when not authorized' do
    it 'must be redirect' do
      expect(subject).to redirect_to root_path
    end
  end

  shared_examples 'when create is authorized' do
    it 'creates a new reservation' do
      expect {
        subject
      }.to change(Reservation, :count).by(1)
    end

    it 'redirects to houses#index' do
      expect(subject).to redirect_to houses_path
    end
  end

  shared_examples 'when destroy is authorized' do
    it 'deletes the reservation' do
      expect{
        subject
      }.to change(Reservation,:count).by(-1)
    end

    it 'redirects to houses#index' do
      expect(subject).to redirect_to houses_path
    end
  end

  describe 'GET #index' do
    let(:house){ create :house, user: controller.current_user }

    let(:another_user) { create :user, email: 't@t.com' }
    let(:another_house) { create :house, user: another_user }

    let(:current_user_reservation) { create :reservation, house: house, user: controller.current_user }
    let(:another_user_reservation) { create :reservation, house: another_house, user: another_user }

    subject { get :index }

    context 'when authenticated' do
      include_context 'is logged in'

      context 'as customer' do
        let(:role) { :customer }

        it 'must assing only current user reservations' do
          expect{ subject }.to change{ assigns(:reservations) }.to([current_user_reservation])
        end
      end

      context 'as admin' do
        let(:role) { :admin }

        it 'must assing only current user reservations' do
          expect{ subject }.to change{ assigns(:reservations) }.to([current_user_reservation, another_user_reservation])
        end
      end

      context 'as agent' do
        let(:role) { :agent }

        it 'must assing only current user reservations' do
          expect{ subject }.to change{ assigns(:reservations) }.to([current_user_reservation, another_user_reservation])
        end
      end
    end

    context 'when not authenticated' do
      subject { get :index }

      it_behaves_like 'not logged in'
    end
  end

  describe 'POST #create' do
    let(:house) { create :house, user: controller.current_user }

    subject { post :create, house_id: house }

    context 'when authenticated' do
      include_context 'is logged in'

      context 'as customer' do
        let(:role) { :customer }

        it_behaves_like 'when create is authorized'
      end

      context 'as admin' do
        let(:role) { :admin }

        it_behaves_like 'when create is authorized'
      end

      context 'as agent' do
        let(:role) { :agent }

        it_behaves_like 'when not authorized'
      end
    end

    context 'when not authenticated' do
      subject { get :index }

      it_behaves_like 'not logged in'
    end
  end

  describe 'DELETE #destroy' do

    subject { delete :destroy, house_id: house, id: controller.current_user }

    context 'when authenticated' do
      include_context 'is logged in'

      let(:house) { create :house, user: controller.current_user }
      let!(:reservation) { create :reservation, house: house, user: controller.current_user }

      context 'as customer' do
        let(:role) { :customer }

        it_behaves_like 'when destroy is authorized'
      end

      context 'as admin' do
        let(:role) { :admin }

        it_behaves_like 'when destroy is authorized'
      end

      context 'as agent' do
        let(:role) { :agent }

        it_behaves_like 'when not authorized'
      end
    end

    context 'when not authenticated' do
      subject { get :index }

      it_behaves_like 'not logged in'
    end
  end
end
