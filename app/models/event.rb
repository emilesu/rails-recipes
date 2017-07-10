class Event < ApplicationRecord

  mount_uploader :logo, EventLogoUploader             #上传单图

  mount_uploaders :images, EventImageUploader         #上传多图
  serialize :images, JSON

  has_many :attachments, :class_name => "EventAttachment", :dependent => :destroy       #新建 model 上传多图
  accepts_nested_attributes_for :attachments, :allow_destroy => true, :reject_if => :all_blank



  validates_presence_of :name, :friendly_id

  validates_uniqueness_of :friendly_id
  validates_format_of :friendly_id, :with => /\A[a-z0-9\-]+\z/

  before_validation :gennerat_friendly_id, :on => :create

  def to_param
   self.friendly_id
  end

  protected

  def gennerat_friendly_id
   self.friendly_id ||= SecureRandom.uuid
  end

  STATUS = ["draft", "public", "private"]
  validates_inclusion_of :status, :in => STATUS      #status的范围

  belongs_to :category, :optional => true

  has_many :tickets, :dependent => :destroy
  accepts_nested_attributes_for :tickets, :allow_destroy => true, :reject_if => :all_blank


  include RankedModel
  ranks :row_order


  has_many :registrations, :dependent => :destroy


  scope :only_public, -> { where( :status => "public" ) }
  scope :only_available, -> { where( :status => ["public", "private"] ) }



end
