local colors = {
  <* for name, value in colors *>
  {{ name }} = "{{ value.default.hex }}",
  <* endfor *>
}
return {
  normal = {
    a = { bg = colors.primary_container, fg = colors.on_primary_container, gui = "bold" },
    b = { bg = colors.surface_variant, fg = colors.on_surface },
    c = { bg = colors.surface_container_high, fg = colors.on_surface },
  },
  insert = {
    a = { bg = colors.primary, fg = colors.on_primary, gui = "bold" },
    b = { bg = colors.surface_variant, fg = colors.on_surface },
    c = { bg = colors.surface_container_high, fg = colors.on_surface },
  },
  visual = {
    a = { bg = colors.tertiary, fg = colors.on_tertiary, gui = "bold" },
    b = { bg = colors.surface_variant, fg = colors.on_surface },
    c = { bg = colors.surface_container_high, fg = colors.on_surface},
  },
  replace = {
    a = { bg = colors.error_container, fg = colors.on_error_container, gui = "bold" },
    b = { bg = colors.surface_variant, fg = colors.on_surface },
    c = { bg = colors.surface_container_high, fg = colors.on_surface },
  },
  command = {
    a = { bg = colors.secondary, fg = colors.on_secondary, gui = "bold" },
    b = { bg = colors.surface_variant, fg = colors.on_surface },
    c = { bg = colors.surface_container_high, fg = colors.on_surface },
  },
  inactive = {
    a = { bg = colors.surface_container_highest, fg = colors.on_surface, gui = "bold" },
    b = { bg = colors.surface_variant, fg = colors.on_surface },
    c = { bg = colors.surface_container_high, fg = colors.on_surface },
  },
}
