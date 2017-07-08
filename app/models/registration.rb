class Registration < ApplicationRecord

  STATUS = ["pending", "confirmed"]
  validates_inclusion_of :status, :in => STATUS         #验证只有某些值
  validates_presence_of :status, :ticket_id

  attr_accessor :current_step         #attr_accessor 是一个虚拟属性，并不会存入数据库，用以代表当前是哪一步
  validates_presence_of :name, :email, :cellphone, :if => :should_validate_basic_data?
  validates_presence_of :name, :email, :cellphone, :bio, :if => :should_validate_all_data?

  belongs_to :event
  belongs_to :ticket
  belongs_to :user, :optional => true

  before_validation :generate_uuid, :on => :create

  def to_param
    self.uuid
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def should_validate_basic_data?
    current_step == 2  # 只有做到第二步需要验证
  end

  def should_validate_all_data?
    current_step == 3 || status == "confirmed"  # 做到第三步，或最后状态是 confirmed 时需要验证
  end

end
