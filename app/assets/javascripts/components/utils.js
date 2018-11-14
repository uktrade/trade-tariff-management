function ordinal(n) {
  var nHundreds = n % 100;
  var nDecimal = n % 10;

  if ([11, 12, 13].indexOf(nHundreds) > -1) {
    return n + "th"
  }

  if (nDecimal === 1) {
    return n + "st";
  } else if (nDecimal === 2) {
    return n + "nd";
  } else if (nDecimal === 3) {
    return n + "rd";
  }

  return n + "th";
}

function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this, args = arguments;
    var later = function() {
      timeout = null;
      if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  };
};

function clone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function objectToArray(obj) {
  var arr = [];

  for (var k in obj) {
    if (obj.hasOwnProperty(k)) {
      arr.push(obj[k]);
    }
  }

  return arr;
}

function any(arr, func) {
  return arr.filter(function(obj, index) {
    return func(obj, index);
  }).length > 0;
}

function retryAjax(options, retries, time, success, error) {
  var _retries = 0;

  options.success = success;
  options.error = function() {
    if (_retries == retries) {
      error();
      return;
    }

    _retries++;
    var ajaxThis = this;

    setTimeout(function() {
      $.ajax(ajaxThis);
    }, time);
  };

  $.ajax(options);
}

function makeRandomString() {
  return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
}

function makeBigNumber() {
  // temporary ids should start high to avoid clashes
  return "9" + Math.random().toString().slice(2,10);
}

function getSearchParam(param) {
  var params = {};
  window.location.search.replace("?", "").split("&").forEach(function(s) {
    var parts = s.split("=");
    params[parts[0]] = parts[1];
  });

  return params[param];
}

function isObject(obj) {
  return obj === Object(obj) && Object.prototype.toString.call(obj) !== '[object Array]';
}

function allValuesSame(arr) {
  for(var i = 1; i < arr.length; i++)
  {
    if(arr[i] !== arr[0]) {
      return false;
    }
  }

  return true;
}

function lockBackHistory() {
  history.pushState(null, null, location.href);
  window.onpopstate = function () {
    history.go(1);
  };
}
