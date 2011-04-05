// event date picker
$(function() {
  $('#event_start_at').datetimepicker({
    stepHour: 1,
    stepMinute: 15,
    ampm: true,
    hourGrid: 4,
    minuteGrid: 15,
    americanMode: true,
    separator: ' @ '
  });
  $('#event_stop_at').datetimepicker({
    stepHour: 1,
    stepMinute: 15,
    ampm: true,
    hourGrid: 4,
    minuteGrid: 15,
    americanMode: true,
    separator: ' @ '
  });
});