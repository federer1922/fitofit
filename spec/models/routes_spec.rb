require 'rails_helper'

RSpec.describe Route, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:starting_adress) }
  end
end
