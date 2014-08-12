class User < ActiveRecord::Base
  VALID_AGE_RANGES = ['0-15', '16-17', '18-20', '21-24', '25-34', '35-44', '45-54', '55-64', '65-74', '75+']

  def field_order
    [:first_name, :email, :password, :post_code]
  end

  devise :registerable,
         :database_authenticatable,
         :encryptable
         # :timeoutable,
         # :confirmable,
         # :invitable,
         # :recoverable,
         # :trackable,
         # :crm_authenticatable,
         # :lockable

  before_validation :uppercase_post_code

  validates_with Validators::Email, attributes: [:email]
  validates :email, uniqueness: true
  validates :post_code, presence: true,
                        format: { with: /\A[A-Z]{1,2}\d{1,2}[A-NP-Z]? ?\d[A-Z]{2}\z/, if: 'post_code.present?' },
                        on: :create
  validates :password, length: 7..128
  validates :first_name, presence: true,
                         format: { with: /\A[A-Za-z '-\.]+\z/, if: 'last_name.present?' },
                         length: { maximum: 24 }
  validates :last_name, format: { with: /\A[A-Za-z '-\.]+\z/ },
                        allow_blank: true,
                        length: { maximum: 24 }
  validates :gender, inclusion: { in: ['female', 'male'] }, allow_nil: true
  validates :date_of_birth, timeliness: { before: Date.today, allow_nil: true, type: :date }
  validates :age_range, inclusion: { in: VALID_AGE_RANGES }, allow_nil: true

  before_save :fake_send_confirmation_email

  private

  def uppercase_post_code
    self.post_code.upcase! if post_code
  end

  def fake_send_confirmation_email
    #Temporary fix to trick Devise into thinking an email confirmation is sent to the user so they can sign in desktop site.
    self.confirmation_sent_at = DateTime.now
  end
end
