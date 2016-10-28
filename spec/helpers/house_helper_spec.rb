require 'rails_helper'
RSpec.describe OperationsHelper, type: :helper do
  describe 'user_has_reserved?' do
    let(:user){ create :user }
    let(:house){ create :house, user: user }

    let!(:reservation){ create :reservation, house: house, user: user }

    context 'when reservation exist' do
      subject{ Reservation.exists?(user_id: user, house_id: house) }

      it { is_expected.to be_truthy }
    end

    context 'when reservation does not exist' do
      let(:another_house){ create :house, user: user }
      subject{ Reservation.exists?(user_id: user, house_id: another_house) }

      it { is_expected.to be_falsy }
    end
  end
end
