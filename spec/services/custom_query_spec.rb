require 'spec_helper'

describe 'Custom Query service', type: :unit do
  describe 'Executes sql' do
    it 'returns results in array' do
      create_list :device, 5

      result = CustomQuery.new('select * from devices').execute

      expect(result.class).to eq Array
      expect(result.count).to eq 5
      expect(result.first.class).to eq Hash
    end
  end

  describe 'Returns specific row fields' do
    it '"0/particle_id" => result[0]["particle_id"]' do
      create :device, particle_id: 'zealot'
      create :device, particle_id: 'zumba'

      custom_query = CustomQuery.new('select * from devices order by id')

      expect(custom_query.find_value('0|particle_id')).to eq 'zealot'
    end

    it 'Raise argument error if path is malformed' do
      expect do
        CustomQuery.new('select * from devices').find_value('0/')
      end.to raise_exception ArgumentError

      expect do
        CustomQuery.new('select * from devices').find_value('|particle_id')
      end.to raise_exception ArgumentError

      expect do
        CustomQuery.new('select * from devices').find_value('0|')
      end.to raise_exception ArgumentError

      expect do
        CustomQuery.new('select * from devices').find_value('0|particle_id')
      end.to raise_exception ArgumentError
    end
  end
end
