require 'spec_helper'

describe JSONArraySerializer do
  context 'without arguments to .new' do
    let(:serializer) { JSONArraySerializer.new }

    describe '.new' do
      it 'sets it\'s element class to a Hash' do
        expect(serializer.element_class).to eq(Hash)
      end
    end

    describe '#load' do
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

      it 'loads arrays of JSON with data' do
        array = Array.new(5, "{\"foo\":\"bar\",\"baz\":1337}")
        expect(serializer.load(array).first).to eq({'foo' => 'bar', 'baz' => 1337})
      end
    end

    describe '#dump' do
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

      it 'dumps hashes with data' do
        array = Array.new(5, {foo: 'bar', baz: 1337})
        expect(serializer.dump(array).first).to eq("{\"foo\":\"bar\",\"baz\":1337}")
      end
    end

    it 'dumps and loads equivalent arrays' do
      array = [
        { 'foo' => 'bar' },
        { 'name' => 'nate', 'age' => 21 },
        { 'ramble' => 'rara', 'float' => 21.13 }
      ]
      expect(serializer.load(serializer.dump(array))).to eq(array)
    end

    it 'converts symbols to strings' do
      array = [
        { foo: 'bar' },
        { name: 'nate', age: 21 },
        { ramble: 'rara', float: 21.13 },
        { symbol: :very_symbol },
        { hash: { 'foo' => 'bar' } },
        { symbol_hash: { foo: 'bar' } }
      ]
      expected = array.map(&:stringify_hash)
      expect(serializer.load(serializer.dump(array))).to eq(expected)
    end
  end

  context 'with class argument to .new' do
    let(:serializer) { JSONArraySerializer.new(OpenStruct) }

    describe '.new' do
      it 'sets it\'s element class to a OpenStruct' do
        expect(serializer.element_class).to eq(OpenStruct)
      end
    end

    describe '#load' do
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

      it 'loads arrays of JSON with data' do
        array = Array.new(5, "{\"foo\":\"bar\",\"baz\":1337}")
        expect(serializer.load(array).first).to eq(OpenStruct.new(foo: 'bar', baz: 1337))
      end
    end

    describe '#dump' do
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

      it 'dumps OpenStructs with data' do
        array = Array.new(5, OpenStruct.new(foo: 'bar', baz: 1337))
        expect(serializer.dump(array).first).to eq("{\"foo\":\"bar\",\"baz\":1337}")
      end
    end
  end
end
