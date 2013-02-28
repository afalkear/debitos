# == Schema Information
#
# Table name: alumnos
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  last_name    :string(255)
#  identifier   :string(255)
#  amount       :decimal(8, 2)
#  card_number  :string(255)
#  card_type    :string(255)
#  card_company :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  padma_id     :string(255)
#  instructor   :string(255)
#  plan         :string(255)
#  due_date     :string(255)
#  payed        :boolean          default(FALSE)
#  payment      :string(255)
#  observations :string(255)
#  bill         :string(255)
#  active       :boolean          default(TRUE)
#  new_debit    :boolean          default(TRUE)
#

require 'spec_helper'

describe Alumno do
  pending "add some examples to (or delete) #{__FILE__}"
end
