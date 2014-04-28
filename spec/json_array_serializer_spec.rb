require 'spec_helper'

describe JSONArraySerializer do
  let(:array) { Array.new(5, foo: 'bar', baz: 1337) }
  let(:array_string) { JSON.dump(array) }
  let(:serializer) { JSONArraySerializer.new }

  describe '#load' do
    it 'returns nil given nil' do
      expect(serializer.load(nil)).to eq(nil)
    end

    it 'returns an empty array given an empty array' do
      expect(serializer.load('[]')).to eq([])
    end

    it 'returns an array of the same length as it\'s given' do
      expect(serializer.load(array_string).length).to eq(array.length)
    end
  end

  describe '#dump' do
    it 'returns nil given nil' do
      expect(serializer.dump(nil)).to eq(nil)
    end

    it 'returns a string given an array' do
      expect(serializer.dump(array)).to be_a(String)
    end
  end

  it 'converts symbols to strings' do
    symbol_array = [
      { foo: 'bar' },
      { name: 'nate', age: 21 },
      { ramble: 'rara', float: 21.13 },
      { symbol: :very_symbol },
      { hash: { 'foo' => 'bar' } },
      { symbol_hash: { foo: 'bar' } }
    ]
    expected = symbol_array.map(&:stringify)
    expect(serializer.load(serializer.dump(symbol_array))).to eq(expected)
  end

  context 'with default array_class (Array)' do
    let(:serializer) { JSONArraySerializer.new }

    describe '.new' do
      it 'sets it\'s array class to Array' do
        expect(serializer.array_class).to eq(Array)
      end
    end

    describe '#load' do
      it 'returns an instance of Array' do
        expect(serializer.load(array_string)).to be_a(Array)
      end
    end

    describe '#dump' do
      it 'returns a string given an Array' do
        expect(serializer.dump(array)).to be_a(String)
      end

      it 'JSON can load it' do
        expect { JSON.load(serializer.dump(array)) }.not_to raise_error
      end
    end
  end

  context 'with CustomArray array_class' do
    class CustomArray
      def initialize(array)
        @arr = array
      end

      def to_a
        @arr
      end
    end

    let(:serializer) { JSONArraySerializer.new(array_class: CustomArray) }

    describe '.new' do
      it 'sets it\'s array class to CustomArray' do
        expect(serializer.array_class).to eq(CustomArray)
      end
    end

    describe '#load' do
      it 'returns an instance of CustomArray' do
        expect(serializer.load(array_string)).to be_a(CustomArray)
      end
    end

    describe '#dump' do
      let(:custom_array) { CustomArray.new([{foo: 'bar'}, {}]) }
      it 'returns a string given an CustomArray' do
        expect(serializer.dump(custom_array)).to be_a(String)
      end

      it 'JSON can load it' do
        expect { JSON.load(serializer.dump(custom_array)) }.not_to raise_error
      end
    end
  end

  context 'with default element_class (Hash)' do
    let(:serializer) { JSONArraySerializer.new }

    describe '.new' do
      it 'sets it\'s element class to a Hash' do
        expect(serializer.element_class).to eq(Hash)
      end
    end

    describe '#load' do
      it 'has elements that are in fact Hashs' do
        expect(serializer.load(array_string).reject { |e| e.is_a? Hash }).to be_empty
      end
    end

    describe '#dump' do
      it 'returns a string given an array of hashes' do
        expect(serializer.dump(array)).to be_a(String)
      end

      it 'JSON can load it' do
        expect { JSON.load(serializer.dump(array)) }.not_to raise_error
      end
    end

    it 'dumps and loads equivalent arrays' do
      hash_array = [
        { 'foo' => 'bar' },
        { 'name' => 'nate', 'age' => 21 },
        { 'ramble' => 'rara', 'float' => 21.13 }
      ]
      expect(serializer.load(serializer.dump(hash_array))).to eq(hash_array)
    end
  end

  context 'with OpenStruct element_class' do
    let(:serializer) { JSONArraySerializer.new(element_class: OpenStruct) }

    describe '.new' do
      it 'sets it\'s element class to a OpenStruct' do
        expect(serializer.element_class).to eq(OpenStruct)
      end
    end

    describe '#load' do
      it 'has elements that are in fact OpenStructs' do
        expect(serializer.load(array_string).reject { |e| e.is_a? OpenStruct }).to be_empty
      end
    end

    describe '#dump' do
      it 'returns a string given an array of OpenStructs' do
        expect(serializer.dump(array)).to be_a(String)
      end

      it 'JSON can load it' do
        expect { JSON.load(serializer.dump(array)) }.not_to raise_error
      end
    end

    it 'dumps and loads equivalent arrays' do
      open_struct_array = [
        OpenStruct.new('foo' => 'bar'),
        OpenStruct.new('name' => 'nate', 'age' => 21),
        OpenStruct.new('ramble' => 'rara', 'float' => 21.13)
      ]
      expect(serializer.load(serializer.dump(open_struct_array))).to eq(open_struct_array)
    end
  end

  context 'with string/text column_type' do
    let(:serializer) { JSONArraySerializer.new(column_type: :text) }

    describe '#load' do
      it 'loads arrays of JSON with data' do
        expect(serializer.load(array_string).first).to eq({'foo' => 'bar', 'baz' => 1337})
      end
    end

    describe '#dump' do
      it 'returns a string given an array' do
        expect(serializer.dump(array)).to be_a(String)
      end

      it 'JSON can load it' do
        expect { JSON.load(serializer.dump(array)) }.not_to raise_error
      end
    end
  end

  context 'with array column_type' do
    let(:serializer) { JSONArraySerializer.new(column_type: :array) }
    let(:array_of_json) { Array.new(5, JSON.dump(foo: 'bar', baz: 1337)) }

    describe '#load' do
      it 'loads arrays of JSON with data' do
        expect(serializer.load(array_of_json).first).to eq({'foo' => 'bar', 'baz' => 1337})
      end
    end

    describe '#dump' do
      it 'returns an array given an array' do
        expect(serializer.dump(array)).to be_a(Array)
      end

      it 'JSON can load it\'s elements' do
        expect { serializer.dump(array).each { |s| JSON.load(s) } }.not_to raise_error
      end
    end
  end
end