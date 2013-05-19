for d in Did.all
  d.assigned_count = 0
  d.save
end