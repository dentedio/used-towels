var fuzzyTime = (function() {
  var exports = {},
    minute = 60,
    hour = minute * 60,
    day = hour * 24,
    week = day * 7;

  exports.inWords = function(dateTimeStamp) {
    var date = new Date(dateTimeStamp * 1000);
    var delta = Math.round((Date.now() - date) / 1000),
      fuzzyText = '';

    if (delta < 30) {
        fuzzyText = 'just then.';
    } else if (delta < minute) {
        fuzzyText = delta + ' seconds ago.';
    } else if (delta < 2 * minute) {
        fuzzyText = 'a minute ago.'
    } else if (delta < hour) {
        fuzzyText = Math.floor(delta / minute) + ' minutes ago.';
    } else if (Math.floor(delta / hour) == 1) {
        fuzzyText = '1 hour ago.'
    } else if (delta < day) {
        fuzzyText = Math.floor(delta / hour) + ' hours ago.';
    } else if (delta < day * 2) {
        fuzzyText = 'yesterday';
    } else {
        fuzzyText = date.toLocaleDateString("en-GB");
    }

    return fuzzyText;
  };

  exports.isWithinAWeek = function (dateTimeStamp) {
    var date = new Date(dateTimeStamp * 1000),
        today = new Date();
    return (today.getDate() > date.getDate()) && (today.getDate() - date.getDate()) < 7;
  }

  return exports;

})();