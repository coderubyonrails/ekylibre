# -*- coding: utf-8 -*-
# == License
# Ekylibre - Simple ERP
# Copyright (C) 2008-2013 Brice Texier
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

module Backend::MapsHelper

  def map(resources, options = {}, &block)
    resources = [resources] unless resources.respond_to?(:each)

    data = {}

    global = nil
    data[:geometries] = resources.collect do |resource|
      hash = (block_given? ? yield(resource) : {name: resource.name, shape: resource.shape})
      hash[:url] ||= url_for(controller: "/backend/#{resource.class.name.tableize}", action: :show, id: resource.id)
      if hash[:shape]
        global = (global ? global.merge(hash[:shape]) : Charta::Geometry.new(hash[:shape]))
        hash[:shape] = Charta::Geometry.new(hash[:shape]).transform(:WGS84).to_geojson
      end
      hash
    end

    if global
      data[:view] ||= {}
      data[:view][:bounding_box] = global.bounding_box
    end

    return content_tag(:div, nil, options.merge(data: {map: data.jsonize_keys.to_json}))
  end

end
