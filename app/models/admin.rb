# frozen_string_literal: true

class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  #   devise :database_authenticatable, :registerable,
  #          :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    return nil unless /@gmail.com || @tamu.edu\z/.match?(email)

    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url).find_or_create_by!(email: email)
  end

  has_many :players, dependent: :destroy

  validates :email, :full_name, presence: true

  validates :email, uniqueness: { case_sensitive: false }

  def self.info(current_admin)
    return Admin.where(email: current_admin.email).first unless current_admin.nil?

    nil
  end

  def self.id(current_admin)
    return Admin.where(email: current_admin.email).first.id unless current_admin.nil?

    nil
  end

  def self.name_given_id(id)
    return Admin.where(id: id).first.full_name unless id.nil?

    nil
  end
end
