anp = ActiveNumberingPlan.new
anp.first = NumberingPlan.first.id
anp.last = NumberingPlan.last.id
anp.save