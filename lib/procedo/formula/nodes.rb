module Procedo
  module Formula
    module Nodes
      class Base < Treetop::Runtime::SyntaxNode; end
      class Expression < Base; end
      class Condition < Base; end
      class Operation < Base; end # Abstract
      class Multiplication < Operation; end
      class Division < Operation; end
      class Addition < Operation; end
      class Substraction < Operation; end
      class BooleanExpression < Base; end
      class BooleanOperation < Base; end
      class Conjunction < BooleanOperation; end
      class Disjunction < BooleanOperation; end
      class ExclusiveDisjunction < BooleanOperation; end
      class Test < Base; end # Abstract
      class Comparison < Test; end # Abstract
      class StrictSuperiorityComparison < Comparison; end
      class StrictInferiortyComparison < Comparison; end
      class SuperiorityComparison < Comparison; end
      class InferiorityComparison < Comparison; end
      class EqualityComparison < Comparison; end
      class DifferenceComparison < Comparison; end
      class IndicatorPresenceTest < Test; end
      class IndividualIndicatorPresenceTest < Test; end
      class VariablePresenceTest < Test; end
      class NegativeTest < Test; end
      class Reading < Base; end # Abstract
      class IndividualReading < Reading; end
      class WholeReading < Reading; end
      class FunctionCall < Base; end
      class FunctionName < Base; end
      class OtherArgument < Base; end
      class Variable < Base; end
      class Indicator < Base; end
      class Unit < Base; end
      class Self < Base; end
      class Value < Base; end
      class Numeric < Base; end
      class Symbol < Base; end
    end
  end
end