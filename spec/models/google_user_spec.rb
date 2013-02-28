# == Schema Information
#
# Table name: google_users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer
#

require 'spec_helper'

describe GoogleUser do
  pending "add some examples to (or delete) #{__FILE__}"
end
