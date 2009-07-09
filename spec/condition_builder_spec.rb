require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ConditionBuilder do

  before(:each) do
    @cb = ConditionBuilder.new
  end
  
  it 'should not be valid without contents' do
    @cb.should_not be_valid
  end

  it 'should have no statements' do
    @cb.statements.should == 0
  end

  it 'should default kind to :and' do
    @cb.kind.should == :and
  end

  it 'should have default kind as part of list of supported kinds - NOTE: is this too internal to test??' do
    ConditionBuilder::SUPPORTED_KINDS.include?(ConditionBuilder::DEFAULT_KIND).should be_true
  end

  it 'should support :and, :or, :xor and :not' do
    [ :and, :or, :xor, :not ].each do |kind|
      @cb.kind = kind
      @cb.kind.should == kind
    end
  end

  it 'should revert to :and if given invalid input' do
    @cb.kind = :xxx
    @cb.kind.should == :and
  end

  describe 'single condition/criterion' do

    before(:each) do
      @cb.add('something =', 'fff')
    end

    it 'should be valid' do
      @cb.should be_valid
    end

    it 'should have just one condition and criterion' do
      @cb.statements.should == 1
    end

    it 'should generate a condition' do
      @cb.conditions.should == 'something = :something'
    end

    it 'should generate a criterion' do
      @cb.criteria[:something].should == 'fff'
    end
  end

  describe 'multiple conditions/criteria' do

    before(:each) do
      @cb.add('something =', 'fff')
      @cb.add('something_else >', 123)
    end

    it 'should be valid' do
      @cb.should be_valid
    end

    it 'should have two conditions and criteria' do
      @cb.statements.should == 2
    end

    it 'should generate conditions' do
      @cb.conditions.should == 'something = :something AND something_else > :something_else'
    end

    it 'should generate criteria' do
      @cb.criteria[:something].should == 'fff'
      @cb.criteria[:something_else].should == 123
    end

    describe 'experiencing duplicate conditions' do

      it 'should raise exception on duplicate conditions' do
        lambda {
          @cb.add('something =', 'ggg')
        }.should raise_error(ArgumentError)
        @cb.statements.should == 2
      end
    end

    describe 'as type :or' do

      before(:each) do
        @cb.kind = :or
      end

      it 'should generate conditions' do
        @cb.conditions.should == 'something = :something OR something_else > :something_else'
      end

      it 'should generate criteria' do
        @cb.criteria[:something].should == 'fff'
        @cb.criteria[:something_else].should == 123
      end
    end

    describe 'as type :xor' do

      before(:each) do
        @cb.kind = :xor
      end

      it 'should generate conditions' do
        @cb.conditions.should == 'something = :something XOR something_else > :something_else'
      end

      it 'should generate criteria' do
        @cb.criteria[:something].should == 'fff'
        @cb.criteria[:something_else].should == 123
      end
    end

    describe 'as type :not' do

      before(:each) do
        @cb.kind = :not
      end

      it 'should generate conditions' do
        @cb.conditions.should == 'something = :something NOT something_else > :something_else'
      end

      it 'should generate criteria' do
        @cb.criteria[:something].should == 'fff'
        @cb.criteria[:something_else].should == 123
      end
    end
  end

  describe 'with table names' do

    before(:each) do
      @cb.add('some.thing =', 'fff')
      @cb.add('some.thing._else >', 123)
    end

    it 'should be valid' do
      @cb.should be_valid
    end

    it 'should have two conditions and criteria' do
      @cb.statements.should == 2
    end

    it 'should generate conditions' do
      @cb.conditions.should == 'some.thing = :some.thing AND some.thing._else > :some.thing._else'
    end

    it 'should generate criteria' do
      @cb.criteria[:'some.thing'].should == 'fff'
      @cb.criteria[:'some.thing._else'].should == 123
    end
  end

  describe 'joins' do

    it 'a single join' do
      @cb.add_join('table_a', 'field_a', 'table_b', 'field_b')
      @cb.joins.should == 'INNER JOIN table_b ON table_a.field_a = table_b.field_b'
    end

    it 'multiple joins' do
      @cb.add_join('table_a', 'field_a', 'table_b', 'field_b')
      @cb.add_join('table_X', 'field_X', 'table_Y', 'field_Y')
      @cb.joins.should == 'INNER JOIN table_b ON table_a.field_a = table_b.field_b INNER JOIN table_Y ON table_X.field_X = table_Y.field_Y'
    end
  end
end
