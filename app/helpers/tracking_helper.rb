module TrackingHelper
  def link_to_tracking_with_data(**options)
    return unless current_user

    path = if current_user.goals.present?
             goal_tracking_path
           elsif current_user.tasks.present?
             task_tracking_path
           else
             goal_tracking_path
           end

    link_to t('navigation.tracking').upcase, path, options
  end
end
