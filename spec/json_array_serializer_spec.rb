require 'spec_helper'

describe JSONArraySerializer do
  context 'without arguments to .new' do
    let(:serializer) { JSONArraySerializer.new }

    describe '.new' do
      it 'sets it\'s element class to a Hash' do
        expect(serializer.element_class).to eq(Hash)
      end
    end

    describe JSONArraySerializer, '#load' do
      it 'returns an empty array given an empty array' do
        expect(serializer.load([])).to eq([])
      end

      it 'returns an array of the same length as it\'s given' do
        array = Array.new(5, "{}")
        expect(serializer.load(array).length).to eq(array.length)
      end

      it 'has elements that are in fact Hashs' do
        array = Array.new(5, "{}")
        expect(serializer.load(array).reject { |e| e.is_a? Hash }).to be_empty
      end
    end

    describe JSONArraySerializer, '#dump' do
      it 'returns an empty array given an empty array' do
        expect(serializer.dump([])).to eq([])
      end

      it 'returns an array of the same length as it\'s given' do
        array = Array.new(5, {})
        expect(serializer.dump(array).length).to eq(array.length)
      end

      it 'has elements that are JSON strings' do
        array = Array.new(5, {foo: 'bar'})
        expect {
          serializer.dump(array).map { |e| JSON.load(e) }
        }.not_to raise_error
      end
    end
  end

  context 'with class argument to .new' do
    let(:serializer) { JSONArraySerializer.new(OpenStruct) }

    describe '.new' do
      it 'sets it\'s element class to a OpenStruct' do
        expect(serializer.element_class).to eq(OpenStruct)
      end
    end

    describe JSONArraySerializer, '#load' do
      it 'returns an empty array given an empty array' do
        expect(serializer.load([])).to eq([])
      end

      it 'returns an array of the same length as it\'s given' do
        array = Array.new(5, "{}")
        expect(serializer.load(array).length).to eq(array.length)
      end

      it 'has elements that are in fact OpenStructs' do
        array = Array.new(5, "{}")
        expect(serializer.load(array).reject { |e| e.is_a? OpenStruct }).to be_empty
      end
    end

    describe JSONArraySerializer, '#dump' do
      it 'returns an empty array given an empty array' do
        expect(serializer.dump([])).to eq([])
      end

      it 'returns an array of the same length as it\'s given' do
        array = Array.new(5, OpenStruct.new)
        expect(serializer.dump(array).length).to eq(array.length)
      end

      it 'has elements that are JSON strings' do
        array = Array.new(5, OpenStruct.new({foo: 'bar'}))
        expect {
          serializer.dump(array).map { |e| JSON.load(e) }
        }.not_to raise_error
      end
    end
  end
end
