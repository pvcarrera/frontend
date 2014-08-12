require 'spec_helper'

RSpec.describe User, :type => :model do
  let(:attributes) do
    { email:                 'david@example.com',
      password:              'password',
      first_name:            'david',
      post_code:             'NE1 6EE'
    }
  end

  describe '#fake_send_confirmation_email' do
    subject(:user) { described_class.new(attributes) }

    it "sends a fake confirmation email when user is saved" do
      user.save!
      expect(user.confirmation_sent_at).to_not be_nil
    end
  end

  describe 'validations' do
    subject{ described_class.new(attributes) }

    it { should allow_value('PasswordWithMoreThan8Characters').for(:password) }
    it { should allow_value('P@55word').for(:password) }
    it { should allow_value('12345678').for(:password) }
    it { should allow_value('ABCDEFGH').for(:password) }
    it { should allow_value('$$$$$$$$').for(:password) }

    it { should_not allow_value('').for(:password) }
    it { should_not allow_value('123').for(:password) }
    it { should_not allow_value('2$hOrt').for(:password) }

    it { should allow_value('m.fait@thoughtwork.com').for(:email) }
    it { should allow_value('m@t.com').for(:email) }
    it { should_not allow_value('invalid@dress').for(:email) }
    it { should_not allow_value('inv@lid@dress.com').for(:email) }

    it { should allow_value('Michael').for(:first_name) }
    it { should_not allow_value('TWENTY  FIVE   CHARACTERS').for(:first_name) }
    it { should allow_value('TWENTY  FOUR  CHARACTERS').for(:first_name) }
    it { should_not allow_value('TWENTY  FIVE   CHARACTERS').for(:last_name) }
    it { should allow_value('TWENTY  FOUR  CHARACTERS').for(:last_name) }
    it { should allow_value('M F').for(:first_name) }
    it { should allow_value('Michael S.').for(:first_name) }
    it { should_not allow_value('').for(:first_name) }
    it { should_not allow_value(' ').for(:first_name) }
    it { should_not allow_value("\t").for(:first_name) }

    it { validate_uniqueness_of(:email) }

    it { should_not allow_value('WC11 $123').for(:post_code) }
    it { should_not allow_value('WC1!123').for(:post_code) }
    it { should_not allow_value('WC1%&*123').for(:post_code) }
    it { should_not allow_value('W').for(:post_code) }
    it { should_not allow_value('12345678901').for(:post_code) }
    it { should_not allow_value('').for(:post_code) }
    it { should allow_value('EC1N 2TD').for(:post_code) }
    it { should allow_value('EC4 6NW').for(:post_code) }
    it { should allow_value('N7 0HS').for(:post_code) }

    it { should allow_value('male').for(:gender) }
    it { should allow_value('female').for(:gender) }
    it { should_not allow_value('').for(:gender) }
    it { should_not allow_value('other').for(:gender) }
    it { should allow_value(nil).for(:gender) }

    it { should allow_value('0-15').for(:age_range) }
    it { should allow_value('16-17').for(:age_range) }
    it { should allow_value('18-20').for(:age_range) }
    it { should allow_value('21-24').for(:age_range) }
    it { should allow_value('25-34').for(:age_range) }
    it { should allow_value('35-44').for(:age_range) }
    it { should allow_value('45-54').for(:age_range) }
    it { should allow_value('55-64').for(:age_range) }
    it { should allow_value('65-74').for(:age_range) }
    it { should allow_value('75+').for(:age_range) }
    it { should_not allow_value('').for(:age_range) }
    it { should_not allow_value('15-21').for(:age_range) }
    it { should allow_value(nil).for(:age_range) }

    it { should allow_value(nil).for(:date_of_birth) }
    it { should_not allow_value(Date.today).for(:date_of_birth) }
    it { should allow_value(1.days.ago).for(:date_of_birth) }
    it { should allow_value('31/12/1970').for(:date_of_birth) }
    it { should_not allow_value('31/02/1970').for(:date_of_birth) }
  end

  it 'should upcase post code' do
    user = User.create!(attributes.merge(post_code: 'n7 0hs'))
    expect(user.post_code).to eq('N7 0HS')
  end
end