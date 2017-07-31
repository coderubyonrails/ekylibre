module Interventions
  class WorkingDurationService
    attr_reader :intervention, :participations, :product

    def initialize(intervention: nil, participations: {}, product: nil)
      @intervention = intervention
      @participations = participations
      @product = product
    end

    def duration(nature: nil, not_nature: nil)
      return @intervention.working_duration if @participations.empty?

      if worker?
        return @participations
          .map{|participation| participation.working_periods.sum(:duration) }
          .inject(0, :+)
      end

      times = workers_times(nature: nature, not_nature: not_nature)

      if times == 0 ||
          (tractors_count == 0 && prepelled_equipments_count == 0)
        return @intervention.working_duration
      end

      times / (tractors_count + prepelled_equipments_count)
    end

    def duration_in_hours(nature: nil, not_nature: nil)
      quantity = duration(nature: nature, not_nature: not_nature).to_d / 3600

      unit_name = Nomen::Unit.find(:hour).human_name
      unit_name = unit_name.pluralize if quantity > 1

      options = {
        catalog_usage: worker? ? :cost : :travel_cost,
        quantity: quantity,
        unit_name: unit_name
      }

      options[:catalog_item] = @product.default_catalog_item(options[:catalog_usage])
      byebug
      InterventionParameter::AmountComputation.quantity(:catalog, options)
    end

    private

    def worker?
      @product.is_a?(Worker)
    end

    def tractors_count
      @participations
        .select{ |participation| participation.product.try(:tractor?) }
        .size
    end

    def prepelled_equipments_count
      @participations
        .select{ |participation| participation.product.variety.to_sym == :self_prepelled_equipment }
        .size
    end

    def workers_times(nature: nil, not_nature: nil)
      byebug
      worker_working_periods(nature, not_nature)
        .map(&:duration)
        .reduce(0, :+)
    end

    def worker_working_periods(nature, not_nature)
      participations = @participations.select{ |participation| participation.product.is_a?(Worker) }
      working_periods = nil

      if nature.nil? && not_nature.nil?
        return participations.map(&:working_periods).flatten
      end

      unless nature.nil?
        return working_periods_of_nature(participations, nature)
      end

      working_periods_not_nature(participations, nature)
    end

    def working_periods_of_nature(participations, nature, reverse_result: false)
      participations.map do |participation|
        participation.working_periods.select do |working_period|
          if reverse_result == false
            working_period.nature.to_sym == nature
          else
            working_period.nature.to_sym != nature
          end
        end
      end.flatten
    end

    def working_periods_not_nature(participations, nature)
      working_periods_of_nature(participations, nature, reverse_result: true)
    end
  end
end