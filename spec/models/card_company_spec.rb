# == Schema Information
#
# Table name: card_companies
#
#  id            :integer          not null, primary key
#  user_id       :string(255)
#  establishment :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  name          :string(255)
#

require 'spec_helper'

describe CardCompany do
  pending "add some examples to (or delete) #{__FILE__}"
end
