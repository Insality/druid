function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : String(i); }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }
function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }
function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }
function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i]; return arr2; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
var Module = typeof Module != "undefined" ? Module : {};
if (typeof Object.assign == "undefined") {
  Object.assign = function (target, source) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];
      if (!source) continue;
      for (var key in source) {
        if (source.hasOwnProperty(key)) target[key] = source[key];
      }
    }
    return target;
  };
}
var moduleOverrides = Object.assign({}, Module);
var arguments_ = [];
var thisProgram = "./this.program";
var quit_ = function quit_(status, toThrow) {
  throw toThrow;
};
var ENVIRONMENT_IS_WEB = (typeof window === "undefined" ? "undefined" : _typeof(window)) == "object";
var ENVIRONMENT_IS_WORKER = typeof importScripts == "function";
var ENVIRONMENT_IS_NODE = (typeof process === "undefined" ? "undefined" : _typeof(process)) == "object" && _typeof(process.versions) == "object" && typeof process.versions.node == "string";
var scriptDirectory = "";
function locateFile(path) {
  if (Module["locateFile"]) {
    return Module["locateFile"](path, scriptDirectory);
  }
  return scriptDirectory + path;
}
var read_, readAsync, readBinary;
if (ENVIRONMENT_IS_NODE) {
  var fs = require("fs");
  var nodePath = require("path");
  if (ENVIRONMENT_IS_WORKER) {
    scriptDirectory = nodePath.dirname(scriptDirectory) + "/";
  } else {
    scriptDirectory = __dirname + "/";
  }
  read_ = function read_(filename, binary) {
    filename = isFileURI(filename) ? new URL(filename) : nodePath.normalize(filename);
    return fs.readFileSync(filename, binary ? undefined : "utf8");
  };
  readBinary = function readBinary(filename) {
    var ret = read_(filename, true);
    if (!ret.buffer) {
      ret = new Uint8Array(ret);
    }
    return ret;
  };
  readAsync = function readAsync(filename, onload, onerror) {
    var binary = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : true;
    filename = isFileURI(filename) ? new URL(filename) : nodePath.normalize(filename);
    fs.readFile(filename, binary ? undefined : "utf8", function (err, data) {
      if (err) onerror(err);else onload(binary ? data.buffer : data);
    });
  };
  if (!Module["thisProgram"] && process.argv.length > 1) {
    thisProgram = process.argv[1].replace(/\\/g, "/");
  }
  arguments_ = process.argv.slice(2);
  if (typeof module != "undefined") {
    module["exports"] = Module;
  }
  process.on("uncaughtException", function (ex) {
    if (ex !== "unwind" && !(ex instanceof ExitStatus) && !(ex.context instanceof ExitStatus)) {
      throw ex;
    }
  });
  quit_ = function quit_(status, toThrow) {
    process.exitCode = status;
    throw toThrow;
  };
} else if (ENVIRONMENT_IS_WEB || ENVIRONMENT_IS_WORKER) {
  if (ENVIRONMENT_IS_WORKER) {
    scriptDirectory = self.location.href;
  } else if (typeof document != "undefined" && document.currentScript) {
    scriptDirectory = document.currentScript.src;
  }
  if (scriptDirectory.startsWith("blob:")) {
    scriptDirectory = "";
  } else {
    scriptDirectory = scriptDirectory.substr(0, scriptDirectory.replace(/[?#].*/, "").lastIndexOf("/") + 1);
  }
  {
    read_ = function read_(url) {
      var xhr = new XMLHttpRequest();
      xhr.open("GET", url, false);
      xhr.send(null);
      return xhr.responseText;
    };
    if (ENVIRONMENT_IS_WORKER) {
      readBinary = function readBinary(url) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", url, false);
        xhr.responseType = "arraybuffer";
        xhr.send(null);
        return new Uint8Array(xhr.response);
      };
    }
    readAsync = function readAsync(url, onload, onerror) {
      var xhr = new XMLHttpRequest();
      xhr.open("GET", url, true);
      xhr.responseType = "arraybuffer";
      xhr.onload = function () {
        if (xhr.status == 200 || xhr.status == 0 && xhr.response) {
          onload(xhr.response);
          return;
        }
        onerror();
      };
      xhr.onerror = onerror;
      xhr.send(null);
    };
  }
} else {}
var out = Module["print"] || console.log.bind(console);
var err = Module["printErr"] || console.error.bind(console);
Object.assign(Module, moduleOverrides);
moduleOverrides = null;
if (Module["arguments"]) arguments_ = Module["arguments"];
if (Module["thisProgram"]) thisProgram = Module["thisProgram"];
if (Module["quit"]) quit_ = Module["quit"];
var wasmBinary;
if (Module["wasmBinary"]) wasmBinary = Module["wasmBinary"];
if ((typeof WebAssembly === "undefined" ? "undefined" : _typeof(WebAssembly)) != "object") {
  abort("no native wasm support detected");
}
var wasmMemory;
var ABORT = false;
var EXITSTATUS;
function assert(condition, text) {
  if (!condition) {
    abort(text);
  }
}
var HEAP8, HEAPU8, HEAP16, HEAPU16, HEAP32, HEAPU32, HEAPF32, HEAPF64;
function updateMemoryViews() {
  var b = wasmMemory.buffer;
  Module["HEAP8"] = HEAP8 = new Int8Array(b);
  Module["HEAP16"] = HEAP16 = new Int16Array(b);
  Module["HEAPU8"] = HEAPU8 = new Uint8Array(b);
  Module["HEAPU16"] = HEAPU16 = new Uint16Array(b);
  Module["HEAP32"] = HEAP32 = new Int32Array(b);
  Module["HEAPU32"] = HEAPU32 = new Uint32Array(b);
  Module["HEAPF32"] = HEAPF32 = new Float32Array(b);
  Module["HEAPF64"] = HEAPF64 = new Float64Array(b);
}
var INITIAL_MEMORY = Module["INITIAL_MEMORY"] || 33554432;
if (Module["wasmMemory"]) {
  wasmMemory = Module["wasmMemory"];
} else {
  wasmMemory = new WebAssembly.Memory({
    "initial": INITIAL_MEMORY / 65536,
    "maximum": 2147483648 / 65536
  });
}
updateMemoryViews();
INITIAL_MEMORY = wasmMemory.buffer.byteLength;
var __ATPRERUN__ = [];
var __ATINIT__ = [];
var __ATMAIN__ = [];
var __ATEXIT__ = [];
var __ATPOSTRUN__ = [];
var runtimeInitialized = false;
function preRun() {
  if (Module["preRun"]) {
    if (typeof Module["preRun"] == "function") Module["preRun"] = [Module["preRun"]];
    while (Module["preRun"].length) {
      addOnPreRun(Module["preRun"].shift());
    }
  }
  callRuntimeCallbacks(__ATPRERUN__);
}
function initRuntime() {
  runtimeInitialized = true;
  if (!Module["noFSInit"] && !FS.init.initialized) FS.init();
  FS.ignorePermissions = false;
  TTY.init();
  SOCKFS.root = FS.mount(SOCKFS, {}, null);
  callRuntimeCallbacks(__ATINIT__);
}
function preMain() {
  callRuntimeCallbacks(__ATMAIN__);
}
function postRun() {
  if (Module["postRun"]) {
    if (typeof Module["postRun"] == "function") Module["postRun"] = [Module["postRun"]];
    while (Module["postRun"].length) {
      addOnPostRun(Module["postRun"].shift());
    }
  }
  callRuntimeCallbacks(__ATPOSTRUN__);
}
function addOnPreRun(cb) {
  __ATPRERUN__.unshift(cb);
}
function addOnInit(cb) {
  __ATINIT__.unshift(cb);
}
function addOnPostRun(cb) {
  __ATPOSTRUN__.unshift(cb);
}
if (!Math.fround) {
  var froundBuffer = new Float32Array(1);
  Math.fround = function (x) {
    froundBuffer[0] = x;
    return froundBuffer[0];
  };
}
Math.clz32 || (Math.clz32 = function (x) {
  var n = 32;
  var y = x >> 16;
  if (y) {
    n -= 16;
    x = y;
  }
  y = x >> 8;
  if (y) {
    n -= 8;
    x = y;
  }
  y = x >> 4;
  if (y) {
    n -= 4;
    x = y;
  }
  y = x >> 2;
  if (y) {
    n -= 2;
    x = y;
  }
  y = x >> 1;
  if (y) return n - 2;
  return n - x;
});
Math.trunc || (Math.trunc = function (x) {
  return x < 0 ? Math.ceil(x) : Math.floor(x);
});
var runDependencies = 0;
var runDependencyWatcher = null;
var dependenciesFulfilled = null;
function getUniqueRunDependency(id) {
  return id;
}
function addRunDependency(id) {
  var _Module$monitorRunDep;
  runDependencies++;
  (_Module$monitorRunDep = Module["monitorRunDependencies"]) === null || _Module$monitorRunDep === void 0 || _Module$monitorRunDep.call(Module, runDependencies);
}
function removeRunDependency(id) {
  var _Module$monitorRunDep2;
  runDependencies--;
  (_Module$monitorRunDep2 = Module["monitorRunDependencies"]) === null || _Module$monitorRunDep2 === void 0 || _Module$monitorRunDep2.call(Module, runDependencies);
  if (runDependencies == 0) {
    if (runDependencyWatcher !== null) {
      clearInterval(runDependencyWatcher);
      runDependencyWatcher = null;
    }
    if (dependenciesFulfilled) {
      var callback = dependenciesFulfilled;
      dependenciesFulfilled = null;
      callback();
    }
  }
}
function abort(what) {
  var _Module$onAbort;
  (_Module$onAbort = Module["onAbort"]) === null || _Module$onAbort === void 0 || _Module$onAbort.call(Module, what);
  what = "Aborted(" + what + ")";
  err(what);
  ABORT = true;
  EXITSTATUS = 1;
  what += ". Build with -sASSERTIONS for more info.";
  var e = new WebAssembly.RuntimeError(what);
  throw e;
}
var dataURIPrefix = "data:application/octet-stream;base64,";
var isDataURI = function isDataURI(filename) {
  return filename.startsWith(dataURIPrefix);
};
var isFileURI = function isFileURI(filename) {
  return filename.startsWith("file://");
};
var wasmBinaryFile;
wasmBinaryFile = "dmengine_release.wasm";
if (!isDataURI(wasmBinaryFile)) {
  wasmBinaryFile = locateFile(wasmBinaryFile);
}
function getBinarySync(file) {
  if (file == wasmBinaryFile && wasmBinary) {
    return new Uint8Array(wasmBinary);
  }
  if (readBinary) {
    return readBinary(file);
  }
  throw "both async and sync fetching of the wasm failed";
}
function getBinaryPromise(binaryFile) {
  if (!wasmBinary && (ENVIRONMENT_IS_WEB || ENVIRONMENT_IS_WORKER)) {
    if (typeof fetch == "function" && !isFileURI(binaryFile)) {
      return fetch(binaryFile, {
        credentials: "same-origin"
      }).then(function (response) {
        if (!response["ok"]) {
          throw "failed to load wasm binary file at '".concat(binaryFile, "'");
        }
        return response["arrayBuffer"]();
      }).catch(function () {
        return getBinarySync(binaryFile);
      });
    } else if (readAsync) {
      return new Promise(function (resolve, reject) {
        readAsync(binaryFile, function (response) {
          return resolve(new Uint8Array(response));
        }, reject);
      });
    }
  }
  return Promise.resolve().then(function () {
    return getBinarySync(binaryFile);
  });
}
function instantiateArrayBuffer(binaryFile, imports, receiver) {
  return getBinaryPromise(binaryFile).then(function (binary) {
    return WebAssembly.instantiate(binary, imports);
  }).then(receiver, function (reason) {
    err("failed to asynchronously prepare wasm: ".concat(reason));
    abort(reason);
  });
}
function instantiateAsync(binary, binaryFile, imports, callback) {
  if (!binary && typeof WebAssembly.instantiateStreaming == "function" && !isDataURI(binaryFile) && !isFileURI(binaryFile) && !ENVIRONMENT_IS_NODE && typeof fetch == "function") {
    return fetch(binaryFile, {
      credentials: "same-origin"
    }).then(function (response) {
      var result = WebAssembly.instantiateStreaming(response, imports);
      return result.then(callback, function (reason) {
        err("wasm streaming compile failed: ".concat(reason));
        err("falling back to ArrayBuffer instantiation");
        return instantiateArrayBuffer(binaryFile, imports, callback);
      });
    });
  }
  return instantiateArrayBuffer(binaryFile, imports, callback);
}
function createWasm() {
  var info = {
    "a": wasmImports
  };
  function receiveInstance(instance, module) {
    wasmExports = instance.exports;
    wasmTable = wasmExports["Vh"];
    addOnInit(wasmExports["Qh"]);
    removeRunDependency("wasm-instantiate");
    return wasmExports;
  }
  addRunDependency("wasm-instantiate");
  function receiveInstantiationResult(result) {
    receiveInstance(result["instance"]);
  }
  if (Module["instantiateWasm"]) {
    try {
      return Module["instantiateWasm"](info, receiveInstance);
    } catch (e) {
      err("Module.instantiateWasm callback failed with error: ".concat(e));
      return false;
    }
  }
  instantiateAsync(wasmBinary, wasmBinaryFile, info, receiveInstantiationResult);
  return {};
}
var tempDouble;
var tempI64;
var ASM_CONSTS = {
  277608: function _() {
    if (navigator.userAgent.toLowerCase().indexOf("chrome") > -1) {
      console.log("%c    %c    Made with Defold    %c    %c    https://www.defold.com", "background: #fd6623; padding:5px 0; border: 5px;", "background: #272c31; color: #fafafa; padding:5px 0;", "background: #39a3e4; padding:5px 0;", "background: #ffffff; color: #000000; padding:5px 0;");
    } else {
      console.log("Made with Defold -=[ https://www.defold.com ]=-");
    }
  },
  278036: function _($0) {
    var jsResult;
    var isSuccess = 1;
    try {
      jsResult = eval(UTF8ToString($0));
    } catch (err) {
      isSuccess = 0;
      jsResult = err;
    }
    _dmScript_Html5ReportOperationSuccess(isSuccess);
    jsResult += "";
    var stringOnWasmHeap = stringToNewUTF8(jsResult);
    return stringOnWasmHeap;
  },
  278304: function _() {
    document.removeEventListener("click", Module.__defold_interaction_listener);
    document.removeEventListener("keyup", Module.__defold_interaction_listener);
    document.removeEventListener("touchend", Module.__defold_interaction_listener);
    Module.__defold_interaction_listener = undefined;
  },
  278592: function _() {
    Module.__defold_interaction_listener = function () {
      _dmScript_RunInteractionCallback();
    };
    document.addEventListener("click", Module.__defold_interaction_listener);
    document.addEventListener("keyup", Module.__defold_interaction_listener);
    document.addEventListener("touchend", Module.__defold_interaction_listener);
  },
  278913: function _($0) {
    Module.printErr(UTF8ToString($0));
  },
  278952: function _($0) {
    Module.print(UTF8ToString($0));
  }
};
function ExitStatus(status) {
  this.name = "ExitStatus";
  this.message = "Program terminated with exit(".concat(status, ")");
  this.status = status;
}
var callRuntimeCallbacks = function callRuntimeCallbacks(callbacks) {
  while (callbacks.length > 0) {
    callbacks.shift()(Module);
  }
};
function getValue(ptr) {
  var type = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : "i8";
  if (type.endsWith("*")) type = "*";
  switch (type) {
    case "i1":
      return HEAP8[ptr];
    case "i8":
      return HEAP8[ptr];
    case "i16":
      return HEAP16[ptr >> 1];
    case "i32":
      return HEAP32[ptr >> 2];
    case "i64":
      abort("to do getValue(i64) use WASM_BIGINT");
    case "float":
      return HEAPF32[ptr >> 2];
    case "double":
      return HEAPF64[ptr >> 3];
    case "*":
      return HEAPU32[ptr >> 2];
    default:
      abort("invalid type for getValue: ".concat(type));
  }
}
var noExitRuntime = Module["noExitRuntime"] || true;
function setValue(ptr, value) {
  var type = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : "i8";
  if (type.endsWith("*")) type = "*";
  switch (type) {
    case "i1":
      HEAP8[ptr] = value;
      break;
    case "i8":
      HEAP8[ptr] = value;
      break;
    case "i16":
      HEAP16[ptr >> 1] = value;
      break;
    case "i32":
      HEAP32[ptr >> 2] = value;
      break;
    case "i64":
      abort("to do setValue(i64) use WASM_BIGINT");
    case "float":
      HEAPF32[ptr >> 2] = value;
      break;
    case "double":
      HEAPF64[ptr >> 3] = value;
      break;
    case "*":
      HEAPU32[ptr >> 2] = value;
      break;
    default:
      abort("invalid type for setValue: ".concat(type));
  }
}
var UTF8Decoder = typeof TextDecoder != "undefined" ? new TextDecoder("utf8") : undefined;
var UTF8ArrayToString = function UTF8ArrayToString(heapOrArray, idx, maxBytesToRead) {
  var endIdx = idx + maxBytesToRead;
  var endPtr = idx;
  while (heapOrArray[endPtr] && !(endPtr >= endIdx)) ++endPtr;
  if (endPtr - idx > 16 && heapOrArray.buffer && UTF8Decoder) {
    return UTF8Decoder.decode(heapOrArray.subarray(idx, endPtr));
  }
  var str = "";
  while (idx < endPtr) {
    var u0 = heapOrArray[idx++];
    if (!(u0 & 128)) {
      str += String.fromCharCode(u0);
      continue;
    }
    var u1 = heapOrArray[idx++] & 63;
    if ((u0 & 224) == 192) {
      str += String.fromCharCode((u0 & 31) << 6 | u1);
      continue;
    }
    var u2 = heapOrArray[idx++] & 63;
    if ((u0 & 240) == 224) {
      u0 = (u0 & 15) << 12 | u1 << 6 | u2;
    } else {
      u0 = (u0 & 7) << 18 | u1 << 12 | u2 << 6 | heapOrArray[idx++] & 63;
    }
    if (u0 < 65536) {
      str += String.fromCharCode(u0);
    } else {
      var ch = u0 - 65536;
      str += String.fromCharCode(55296 | ch >> 10, 56320 | ch & 1023);
    }
  }
  return str;
};
var UTF8ToString = function UTF8ToString(ptr, maxBytesToRead) {
  return ptr ? UTF8ArrayToString(HEAPU8, ptr, maxBytesToRead) : "";
};
var ___assert_fail = function ___assert_fail(condition, filename, line, func) {
  abort("Assertion failed: ".concat(UTF8ToString(condition), ", at: ") + [filename ? UTF8ToString(filename) : "unknown filename", line, func ? UTF8ToString(func) : "unknown function"]);
};
var PATH = {
  isAbs: function isAbs(path) {
    return path.charAt(0) === "/";
  },
  splitPath: function splitPath(filename) {
    var splitPathRe = /^(\/?|)([\s\S]*?)((?:\.{1,2}|[^\/]+?|)(\.[^.\/]*|))(?:[\/]*)$/;
    return splitPathRe.exec(filename).slice(1);
  },
  normalizeArray: function normalizeArray(parts, allowAboveRoot) {
    var up = 0;
    for (var i = parts.length - 1; i >= 0; i--) {
      var last = parts[i];
      if (last === ".") {
        parts.splice(i, 1);
      } else if (last === "..") {
        parts.splice(i, 1);
        up++;
      } else if (up) {
        parts.splice(i, 1);
        up--;
      }
    }
    if (allowAboveRoot) {
      for (; up; up--) {
        parts.unshift("..");
      }
    }
    return parts;
  },
  normalize: function normalize(path) {
    var isAbsolute = PATH.isAbs(path),
      trailingSlash = path.substr(-1) === "/";
    path = PATH.normalizeArray(path.split("/").filter(function (p) {
      return !!p;
    }), !isAbsolute).join("/");
    if (!path && !isAbsolute) {
      path = ".";
    }
    if (path && trailingSlash) {
      path += "/";
    }
    return (isAbsolute ? "/" : "") + path;
  },
  dirname: function dirname(path) {
    var result = PATH.splitPath(path),
      root = result[0],
      dir = result[1];
    if (!root && !dir) {
      return ".";
    }
    if (dir) {
      dir = dir.substr(0, dir.length - 1);
    }
    return root + dir;
  },
  basename: function basename(path) {
    if (path === "/") return "/";
    path = PATH.normalize(path);
    path = path.replace(/\/$/, "");
    var lastSlash = path.lastIndexOf("/");
    if (lastSlash === -1) return path;
    return path.substr(lastSlash + 1);
  },
  join: function join() {
    for (var _len = arguments.length, paths = new Array(_len), _key = 0; _key < _len; _key++) {
      paths[_key] = arguments[_key];
    }
    return PATH.normalize(paths.join("/"));
  },
  join2: function join2(l, r) {
    return PATH.normalize(l + "/" + r);
  }
};
var initRandomFill = function initRandomFill() {
  if ((typeof crypto === "undefined" ? "undefined" : _typeof(crypto)) == "object" && typeof crypto["getRandomValues"] == "function") {
    return function (view) {
      return crypto.getRandomValues(view);
    };
  } else if (ENVIRONMENT_IS_NODE) {
    try {
      var crypto_module = require("crypto");
      var randomFillSync = crypto_module["randomFillSync"];
      if (randomFillSync) {
        return function (view) {
          return crypto_module["randomFillSync"](view);
        };
      }
      var randomBytes = crypto_module["randomBytes"];
      return function (view) {
        return view.set(randomBytes(view.byteLength)), view;
      };
    } catch (e) {}
  }
  abort("initRandomDevice");
};
var _randomFill = function randomFill(view) {
  return (_randomFill = initRandomFill())(view);
};
var PATH_FS = {
  resolve: function resolve() {
    var resolvedPath = "",
      resolvedAbsolute = false;
    for (var i = arguments.length - 1; i >= -1 && !resolvedAbsolute; i--) {
      var path = i >= 0 ? i < 0 || arguments.length <= i ? undefined : arguments[i] : FS.cwd();
      if (typeof path != "string") {
        throw new TypeError("Arguments to path.resolve must be strings");
      } else if (!path) {
        return "";
      }
      resolvedPath = path + "/" + resolvedPath;
      resolvedAbsolute = PATH.isAbs(path);
    }
    resolvedPath = PATH.normalizeArray(resolvedPath.split("/").filter(function (p) {
      return !!p;
    }), !resolvedAbsolute).join("/");
    return (resolvedAbsolute ? "/" : "") + resolvedPath || ".";
  },
  relative: function relative(from, to) {
    from = PATH_FS.resolve(from).substr(1);
    to = PATH_FS.resolve(to).substr(1);
    function trim(arr) {
      var start = 0;
      for (; start < arr.length; start++) {
        if (arr[start] !== "") break;
      }
      var end = arr.length - 1;
      for (; end >= 0; end--) {
        if (arr[end] !== "") break;
      }
      if (start > end) return [];
      return arr.slice(start, end - start + 1);
    }
    var fromParts = trim(from.split("/"));
    var toParts = trim(to.split("/"));
    var length = Math.min(fromParts.length, toParts.length);
    var samePartsLength = length;
    for (var i = 0; i < length; i++) {
      if (fromParts[i] !== toParts[i]) {
        samePartsLength = i;
        break;
      }
    }
    var outputParts = [];
    for (var i = samePartsLength; i < fromParts.length; i++) {
      outputParts.push("..");
    }
    outputParts = outputParts.concat(toParts.slice(samePartsLength));
    return outputParts.join("/");
  }
};
var FS_stdin_getChar_buffer = [];
var lengthBytesUTF8 = function lengthBytesUTF8(str) {
  var len = 0;
  for (var i = 0; i < str.length; ++i) {
    var c = str.charCodeAt(i);
    if (c <= 127) {
      len++;
    } else if (c <= 2047) {
      len += 2;
    } else if (c >= 55296 && c <= 57343) {
      len += 4;
      ++i;
    } else {
      len += 3;
    }
  }
  return len;
};
var stringToUTF8Array = function stringToUTF8Array(str, heap, outIdx, maxBytesToWrite) {
  if (!(maxBytesToWrite > 0)) return 0;
  var startIdx = outIdx;
  var endIdx = outIdx + maxBytesToWrite - 1;
  for (var i = 0; i < str.length; ++i) {
    var u = str.charCodeAt(i);
    if (u >= 55296 && u <= 57343) {
      var u1 = str.charCodeAt(++i);
      u = 65536 + ((u & 1023) << 10) | u1 & 1023;
    }
    if (u <= 127) {
      if (outIdx >= endIdx) break;
      heap[outIdx++] = u;
    } else if (u <= 2047) {
      if (outIdx + 1 >= endIdx) break;
      heap[outIdx++] = 192 | u >> 6;
      heap[outIdx++] = 128 | u & 63;
    } else if (u <= 65535) {
      if (outIdx + 2 >= endIdx) break;
      heap[outIdx++] = 224 | u >> 12;
      heap[outIdx++] = 128 | u >> 6 & 63;
      heap[outIdx++] = 128 | u & 63;
    } else {
      if (outIdx + 3 >= endIdx) break;
      heap[outIdx++] = 240 | u >> 18;
      heap[outIdx++] = 128 | u >> 12 & 63;
      heap[outIdx++] = 128 | u >> 6 & 63;
      heap[outIdx++] = 128 | u & 63;
    }
  }
  heap[outIdx] = 0;
  return outIdx - startIdx;
};
function intArrayFromString(stringy, dontAddNull, length) {
  var len = length > 0 ? length : lengthBytesUTF8(stringy) + 1;
  var u8array = new Array(len);
  var numBytesWritten = stringToUTF8Array(stringy, u8array, 0, u8array.length);
  if (dontAddNull) u8array.length = numBytesWritten;
  return u8array;
}
var FS_stdin_getChar = function FS_stdin_getChar() {
  if (!FS_stdin_getChar_buffer.length) {
    var result = null;
    if (ENVIRONMENT_IS_NODE) {
      var BUFSIZE = 256;
      var buf = Buffer.alloc(BUFSIZE);
      var bytesRead = 0;
      var fd = process.stdin.fd;
      try {
        bytesRead = fs.readSync(fd, buf);
      } catch (e) {
        if (e.toString().includes("EOF")) bytesRead = 0;else throw e;
      }
      if (bytesRead > 0) {
        result = buf.slice(0, bytesRead).toString("utf-8");
      } else {
        result = null;
      }
    } else if (typeof window != "undefined" && typeof window.prompt == "function") {
      result = window.prompt("Input: ");
      if (result !== null) {
        result += "\n";
      }
    } else if (typeof readline == "function") {
      result = readline();
      if (result !== null) {
        result += "\n";
      }
    }
    if (!result) {
      return null;
    }
    FS_stdin_getChar_buffer = intArrayFromString(result, true);
  }
  return FS_stdin_getChar_buffer.shift();
};
var TTY = {
  ttys: [],
  init: function init() {},
  shutdown: function shutdown() {},
  register: function register(dev, ops) {
    TTY.ttys[dev] = {
      input: [],
      output: [],
      ops: ops
    };
    FS.registerDevice(dev, TTY.stream_ops);
  },
  stream_ops: {
    open: function open(stream) {
      var tty = TTY.ttys[stream.node.rdev];
      if (!tty) {
        throw new FS.ErrnoError(43);
      }
      stream.tty = tty;
      stream.seekable = false;
    },
    close: function close(stream) {
      stream.tty.ops.fsync(stream.tty);
    },
    fsync: function fsync(stream) {
      stream.tty.ops.fsync(stream.tty);
    },
    read: function read(stream, buffer, offset, length, pos) {
      if (!stream.tty || !stream.tty.ops.get_char) {
        throw new FS.ErrnoError(60);
      }
      var bytesRead = 0;
      for (var i = 0; i < length; i++) {
        var result;
        try {
          result = stream.tty.ops.get_char(stream.tty);
        } catch (e) {
          throw new FS.ErrnoError(29);
        }
        if (result === undefined && bytesRead === 0) {
          throw new FS.ErrnoError(6);
        }
        if (result === null || result === undefined) break;
        bytesRead++;
        buffer[offset + i] = result;
      }
      if (bytesRead) {
        stream.node.timestamp = Date.now();
      }
      return bytesRead;
    },
    write: function write(stream, buffer, offset, length, pos) {
      if (!stream.tty || !stream.tty.ops.put_char) {
        throw new FS.ErrnoError(60);
      }
      try {
        for (var i = 0; i < length; i++) {
          stream.tty.ops.put_char(stream.tty, buffer[offset + i]);
        }
      } catch (e) {
        throw new FS.ErrnoError(29);
      }
      if (length) {
        stream.node.timestamp = Date.now();
      }
      return i;
    }
  },
  default_tty_ops: {
    get_char: function get_char(tty) {
      return FS_stdin_getChar();
    },
    put_char: function put_char(tty, val) {
      if (val === null || val === 10) {
        out(UTF8ArrayToString(tty.output, 0));
        tty.output = [];
      } else {
        if (val != 0) tty.output.push(val);
      }
    },
    fsync: function fsync(tty) {
      if (tty.output && tty.output.length > 0) {
        out(UTF8ArrayToString(tty.output, 0));
        tty.output = [];
      }
    },
    ioctl_tcgets: function ioctl_tcgets(tty) {
      return {
        c_iflag: 25856,
        c_oflag: 5,
        c_cflag: 191,
        c_lflag: 35387,
        c_cc: [3, 28, 127, 21, 4, 0, 1, 0, 17, 19, 26, 0, 18, 15, 23, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      };
    },
    ioctl_tcsets: function ioctl_tcsets(tty, optional_actions, data) {
      return 0;
    },
    ioctl_tiocgwinsz: function ioctl_tiocgwinsz(tty) {
      return [24, 80];
    }
  },
  default_tty1_ops: {
    put_char: function put_char(tty, val) {
      if (val === null || val === 10) {
        err(UTF8ArrayToString(tty.output, 0));
        tty.output = [];
      } else {
        if (val != 0) tty.output.push(val);
      }
    },
    fsync: function fsync(tty) {
      if (tty.output && tty.output.length > 0) {
        err(UTF8ArrayToString(tty.output, 0));
        tty.output = [];
      }
    }
  }
};
var zeroMemory = function zeroMemory(address, size) {
  HEAPU8.fill(0, address, address + size);
  return address;
};
var mmapAlloc = function mmapAlloc(size) {
  abort();
};
var MEMFS = {
  ops_table: null,
  mount: function mount(_mount) {
    return MEMFS.createNode(null, "/", 16384 | 511, 0);
  },
  createNode: function createNode(parent, name, mode, dev) {
    if (FS.isBlkdev(mode) || FS.isFIFO(mode)) {
      throw new FS.ErrnoError(63);
    }
    MEMFS.ops_table || (MEMFS.ops_table = {
      dir: {
        node: {
          getattr: MEMFS.node_ops.getattr,
          setattr: MEMFS.node_ops.setattr,
          lookup: MEMFS.node_ops.lookup,
          mknod: MEMFS.node_ops.mknod,
          rename: MEMFS.node_ops.rename,
          unlink: MEMFS.node_ops.unlink,
          rmdir: MEMFS.node_ops.rmdir,
          readdir: MEMFS.node_ops.readdir,
          symlink: MEMFS.node_ops.symlink
        },
        stream: {
          llseek: MEMFS.stream_ops.llseek
        }
      },
      file: {
        node: {
          getattr: MEMFS.node_ops.getattr,
          setattr: MEMFS.node_ops.setattr
        },
        stream: {
          llseek: MEMFS.stream_ops.llseek,
          read: MEMFS.stream_ops.read,
          write: MEMFS.stream_ops.write,
          allocate: MEMFS.stream_ops.allocate,
          mmap: MEMFS.stream_ops.mmap,
          msync: MEMFS.stream_ops.msync
        }
      },
      link: {
        node: {
          getattr: MEMFS.node_ops.getattr,
          setattr: MEMFS.node_ops.setattr,
          readlink: MEMFS.node_ops.readlink
        },
        stream: {}
      },
      chrdev: {
        node: {
          getattr: MEMFS.node_ops.getattr,
          setattr: MEMFS.node_ops.setattr
        },
        stream: FS.chrdev_stream_ops
      }
    });
    var node = FS.createNode(parent, name, mode, dev);
    if (FS.isDir(node.mode)) {
      node.node_ops = MEMFS.ops_table.dir.node;
      node.stream_ops = MEMFS.ops_table.dir.stream;
      node.contents = {};
    } else if (FS.isFile(node.mode)) {
      node.node_ops = MEMFS.ops_table.file.node;
      node.stream_ops = MEMFS.ops_table.file.stream;
      node.usedBytes = 0;
      node.contents = null;
    } else if (FS.isLink(node.mode)) {
      node.node_ops = MEMFS.ops_table.link.node;
      node.stream_ops = MEMFS.ops_table.link.stream;
    } else if (FS.isChrdev(node.mode)) {
      node.node_ops = MEMFS.ops_table.chrdev.node;
      node.stream_ops = MEMFS.ops_table.chrdev.stream;
    }
    node.timestamp = Date.now();
    if (parent) {
      parent.contents[name] = node;
      parent.timestamp = node.timestamp;
    }
    return node;
  },
  getFileDataAsTypedArray: function getFileDataAsTypedArray(node) {
    if (!node.contents) return new Uint8Array(0);
    if (node.contents.subarray) return node.contents.subarray(0, node.usedBytes);
    return new Uint8Array(node.contents);
  },
  expandFileStorage: function expandFileStorage(node, newCapacity) {
    var prevCapacity = node.contents ? node.contents.length : 0;
    if (prevCapacity >= newCapacity) return;
    var CAPACITY_DOUBLING_MAX = 1024 * 1024;
    newCapacity = Math.max(newCapacity, prevCapacity * (prevCapacity < CAPACITY_DOUBLING_MAX ? 2 : 1.125) >>> 0);
    if (prevCapacity != 0) newCapacity = Math.max(newCapacity, 256);
    var oldContents = node.contents;
    node.contents = new Uint8Array(newCapacity);
    if (node.usedBytes > 0) node.contents.set(oldContents.subarray(0, node.usedBytes), 0);
  },
  resizeFileStorage: function resizeFileStorage(node, newSize) {
    if (node.usedBytes == newSize) return;
    if (newSize == 0) {
      node.contents = null;
      node.usedBytes = 0;
    } else {
      var oldContents = node.contents;
      node.contents = new Uint8Array(newSize);
      if (oldContents) {
        node.contents.set(oldContents.subarray(0, Math.min(newSize, node.usedBytes)));
      }
      node.usedBytes = newSize;
    }
  },
  node_ops: {
    getattr: function getattr(node) {
      var attr = {};
      attr.dev = FS.isChrdev(node.mode) ? node.id : 1;
      attr.ino = node.id;
      attr.mode = node.mode;
      attr.nlink = 1;
      attr.uid = 0;
      attr.gid = 0;
      attr.rdev = node.rdev;
      if (FS.isDir(node.mode)) {
        attr.size = 4096;
      } else if (FS.isFile(node.mode)) {
        attr.size = node.usedBytes;
      } else if (FS.isLink(node.mode)) {
        attr.size = node.link.length;
      } else {
        attr.size = 0;
      }
      attr.atime = new Date(node.timestamp);
      attr.mtime = new Date(node.timestamp);
      attr.ctime = new Date(node.timestamp);
      attr.blksize = 4096;
      attr.blocks = Math.ceil(attr.size / attr.blksize);
      return attr;
    },
    setattr: function setattr(node, attr) {
      if (attr.mode !== undefined) {
        node.mode = attr.mode;
      }
      if (attr.timestamp !== undefined) {
        node.timestamp = attr.timestamp;
      }
      if (attr.size !== undefined) {
        MEMFS.resizeFileStorage(node, attr.size);
      }
    },
    lookup: function lookup(parent, name) {
      throw FS.genericErrors[44];
    },
    mknod: function mknod(parent, name, mode, dev) {
      return MEMFS.createNode(parent, name, mode, dev);
    },
    rename: function rename(old_node, new_dir, new_name) {
      if (FS.isDir(old_node.mode)) {
        var new_node;
        try {
          new_node = FS.lookupNode(new_dir, new_name);
        } catch (e) {}
        if (new_node) {
          for (var i in new_node.contents) {
            throw new FS.ErrnoError(55);
          }
        }
      }
      delete old_node.parent.contents[old_node.name];
      old_node.parent.timestamp = Date.now();
      old_node.name = new_name;
      new_dir.contents[new_name] = old_node;
      new_dir.timestamp = old_node.parent.timestamp;
      old_node.parent = new_dir;
    },
    unlink: function unlink(parent, name) {
      delete parent.contents[name];
      parent.timestamp = Date.now();
    },
    rmdir: function rmdir(parent, name) {
      var node = FS.lookupNode(parent, name);
      for (var i in node.contents) {
        throw new FS.ErrnoError(55);
      }
      delete parent.contents[name];
      parent.timestamp = Date.now();
    },
    readdir: function readdir(node) {
      var entries = [".", ".."];
      for (var _i = 0, _Object$keys = Object.keys(node.contents); _i < _Object$keys.length; _i++) {
        var key = _Object$keys[_i];
        entries.push(key);
      }
      return entries;
    },
    symlink: function symlink(parent, newname, oldpath) {
      var node = MEMFS.createNode(parent, newname, 511 | 40960, 0);
      node.link = oldpath;
      return node;
    },
    readlink: function readlink(node) {
      if (!FS.isLink(node.mode)) {
        throw new FS.ErrnoError(28);
      }
      return node.link;
    }
  },
  stream_ops: {
    read: function read(stream, buffer, offset, length, position) {
      var contents = stream.node.contents;
      if (position >= stream.node.usedBytes) return 0;
      var size = Math.min(stream.node.usedBytes - position, length);
      if (size > 8 && contents.subarray) {
        buffer.set(contents.subarray(position, position + size), offset);
      } else {
        for (var i = 0; i < size; i++) buffer[offset + i] = contents[position + i];
      }
      return size;
    },
    write: function write(stream, buffer, offset, length, position, canOwn) {
      if (buffer.buffer === HEAP8.buffer) {
        canOwn = false;
      }
      if (!length) return 0;
      var node = stream.node;
      node.timestamp = Date.now();
      if (buffer.subarray && (!node.contents || node.contents.subarray)) {
        if (canOwn) {
          node.contents = buffer.subarray(offset, offset + length);
          node.usedBytes = length;
          return length;
        } else if (node.usedBytes === 0 && position === 0) {
          node.contents = buffer.slice(offset, offset + length);
          node.usedBytes = length;
          return length;
        } else if (position + length <= node.usedBytes) {
          node.contents.set(buffer.subarray(offset, offset + length), position);
          return length;
        }
      }
      MEMFS.expandFileStorage(node, position + length);
      if (node.contents.subarray && buffer.subarray) {
        node.contents.set(buffer.subarray(offset, offset + length), position);
      } else {
        for (var i = 0; i < length; i++) {
          node.contents[position + i] = buffer[offset + i];
        }
      }
      node.usedBytes = Math.max(node.usedBytes, position + length);
      return length;
    },
    llseek: function llseek(stream, offset, whence) {
      var position = offset;
      if (whence === 1) {
        position += stream.position;
      } else if (whence === 2) {
        if (FS.isFile(stream.node.mode)) {
          position += stream.node.usedBytes;
        }
      }
      if (position < 0) {
        throw new FS.ErrnoError(28);
      }
      return position;
    },
    allocate: function allocate(stream, offset, length) {
      MEMFS.expandFileStorage(stream.node, offset + length);
      stream.node.usedBytes = Math.max(stream.node.usedBytes, offset + length);
    },
    mmap: function mmap(stream, length, position, prot, flags) {
      if (!FS.isFile(stream.node.mode)) {
        throw new FS.ErrnoError(43);
      }
      var ptr;
      var allocated;
      var contents = stream.node.contents;
      if (!(flags & 2) && contents.buffer === HEAP8.buffer) {
        allocated = false;
        ptr = contents.byteOffset;
      } else {
        if (position > 0 || position + length < contents.length) {
          if (contents.subarray) {
            contents = contents.subarray(position, position + length);
          } else {
            contents = Array.prototype.slice.call(contents, position, position + length);
          }
        }
        allocated = true;
        ptr = mmapAlloc(length);
        if (!ptr) {
          throw new FS.ErrnoError(48);
        }
        HEAP8.set(contents, ptr);
      }
      return {
        ptr: ptr,
        allocated: allocated
      };
    },
    msync: function msync(stream, buffer, offset, length, mmapFlags) {
      MEMFS.stream_ops.write(stream, buffer, 0, length, offset, false);
      return 0;
    }
  }
};
var asyncLoad = function asyncLoad(url, onload, onerror, noRunDep) {
  var dep = !noRunDep ? getUniqueRunDependency("al ".concat(url)) : "";
  readAsync(url, function (arrayBuffer) {
    onload(new Uint8Array(arrayBuffer));
    if (dep) removeRunDependency(dep);
  }, function (event) {
    if (onerror) {
      onerror();
    } else {
      throw "Loading data file \"".concat(url, "\" failed.");
    }
  });
  if (dep) addRunDependency(dep);
};
var FS_createDataFile = function FS_createDataFile(parent, name, fileData, canRead, canWrite, canOwn) {
  FS.createDataFile(parent, name, fileData, canRead, canWrite, canOwn);
};
var preloadPlugins = Module["preloadPlugins"] || [];
var FS_handledByPreloadPlugin = function FS_handledByPreloadPlugin(byteArray, fullname, finish, onerror) {
  if (typeof Browser != "undefined") Browser.init();
  var handled = false;
  preloadPlugins.forEach(function (plugin) {
    if (handled) return;
    if (plugin["canHandle"](fullname)) {
      plugin["handle"](byteArray, fullname, finish, onerror);
      handled = true;
    }
  });
  return handled;
};
var FS_createPreloadedFile = function FS_createPreloadedFile(parent, name, url, canRead, canWrite, onload, onerror, dontCreateFile, canOwn, preFinish) {
  var fullname = name ? PATH_FS.resolve(PATH.join2(parent, name)) : parent;
  var dep = getUniqueRunDependency("cp ".concat(fullname));
  function processData(byteArray) {
    function finish(byteArray) {
      preFinish === null || preFinish === void 0 || preFinish();
      if (!dontCreateFile) {
        FS_createDataFile(parent, name, byteArray, canRead, canWrite, canOwn);
      }
      onload === null || onload === void 0 || onload();
      removeRunDependency(dep);
    }
    if (FS_handledByPreloadPlugin(byteArray, fullname, finish, function () {
      onerror === null || onerror === void 0 || onerror();
      removeRunDependency(dep);
    })) {
      return;
    }
    finish(byteArray);
  }
  addRunDependency(dep);
  if (typeof url == "string") {
    asyncLoad(url, processData, onerror);
  } else {
    processData(url);
  }
};
var FS_modeStringToFlags = function FS_modeStringToFlags(str) {
  var flagModes = {
    "r": 0,
    "r+": 2,
    "w": 512 | 64 | 1,
    "w+": 512 | 64 | 2,
    "a": 1024 | 64 | 1,
    "a+": 1024 | 64 | 2
  };
  var flags = flagModes[str];
  if (typeof flags == "undefined") {
    throw new Error("Unknown file open mode: ".concat(str));
  }
  return flags;
};
var FS_getMode = function FS_getMode(canRead, canWrite) {
  var mode = 0;
  if (canRead) mode |= 292 | 73;
  if (canWrite) mode |= 146;
  return mode;
};
var IDBFS = {
  dbs: {},
  indexedDB: function (_indexedDB) {
    function indexedDB() {
      return _indexedDB.apply(this, arguments);
    }
    indexedDB.toString = function () {
      return _indexedDB.toString();
    };
    return indexedDB;
  }(function () {
    if (typeof indexedDB != "undefined") return indexedDB;
    var ret = null;
    if ((typeof window === "undefined" ? "undefined" : _typeof(window)) == "object") ret = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;
    return ret;
  }),
  DB_VERSION: 21,
  DB_STORE_NAME: "FILE_DATA",
  mount: function mount() {
    return MEMFS.mount.apply(MEMFS, arguments);
  },
  syncfs: function syncfs(mount, populate, callback) {
    IDBFS.getLocalSet(mount, function (err, local) {
      if (err) return callback(err);
      IDBFS.getRemoteSet(mount, function (err, remote) {
        if (err) return callback(err);
        var src = populate ? remote : local;
        var dst = populate ? local : remote;
        IDBFS.reconcile(src, dst, callback);
      });
    });
  },
  quit: function quit() {
    Object.values(IDBFS.dbs).forEach(function (value) {
      return value.close();
    });
    IDBFS.dbs = {};
  },
  getDB: function getDB(name, callback) {
    var db = IDBFS.dbs[name];
    if (db) {
      return callback(null, db);
    }
    var req;
    try {
      req = IDBFS.indexedDB().open(name, IDBFS.DB_VERSION);
    } catch (e) {
      return callback(e);
    }
    if (!req) {
      return callback("Unable to connect to IndexedDB");
    }
    req.onupgradeneeded = function (e) {
      var db = e.target.result;
      var transaction = e.target.transaction;
      var fileStore;
      if (db.objectStoreNames.contains(IDBFS.DB_STORE_NAME)) {
        fileStore = transaction.objectStore(IDBFS.DB_STORE_NAME);
      } else {
        fileStore = db.createObjectStore(IDBFS.DB_STORE_NAME);
      }
      if (!fileStore.indexNames.contains("timestamp")) {
        fileStore.createIndex("timestamp", "timestamp", {
          unique: false
        });
      }
    };
    req.onsuccess = function () {
      db = req.result;
      IDBFS.dbs[name] = db;
      callback(null, db);
    };
    req.onerror = function (e) {
      callback(e.target.error);
      e.preventDefault();
    };
  },
  getLocalSet: function getLocalSet(mount, callback) {
    var entries = {};
    function isRealDir(p) {
      return p !== "." && p !== "..";
    }
    function toAbsolute(root) {
      return function (p) {
        return PATH.join2(root, p);
      };
    }
    var check = FS.readdir(mount.mountpoint).filter(isRealDir).map(toAbsolute(mount.mountpoint));
    while (check.length) {
      var path = check.pop();
      var stat;
      try {
        stat = FS.stat(path);
      } catch (e) {
        return callback(e);
      }
      if (FS.isDir(stat.mode)) {
        check.push.apply(check, _toConsumableArray(FS.readdir(path).filter(isRealDir).map(toAbsolute(path))));
      }
      entries[path] = {
        "timestamp": stat.mtime
      };
    }
    return callback(null, {
      type: "local",
      entries: entries
    });
  },
  getRemoteSet: function getRemoteSet(mount, callback) {
    var entries = {};
    IDBFS.getDB(mount.mountpoint, function (err, db) {
      if (err) return callback(err);
      try {
        var transaction = db.transaction([IDBFS.DB_STORE_NAME], "readonly");
        transaction.onerror = function (e) {
          callback(e.target.error);
          e.preventDefault();
        };
        var store = transaction.objectStore(IDBFS.DB_STORE_NAME);
        var index = store.index("timestamp");
        index.openKeyCursor().onsuccess = function (event) {
          var cursor = event.target.result;
          if (!cursor) {
            return callback(null, {
              type: "remote",
              db: db,
              entries: entries
            });
          }
          entries[cursor.primaryKey] = {
            "timestamp": cursor.key
          };
          cursor.continue();
        };
      } catch (e) {
        return callback(e);
      }
    });
  },
  loadLocalEntry: function loadLocalEntry(path, callback) {
    var stat, node;
    try {
      var lookup = FS.lookupPath(path);
      node = lookup.node;
      stat = FS.stat(path);
    } catch (e) {
      return callback(e);
    }
    if (FS.isDir(stat.mode)) {
      return callback(null, {
        "timestamp": stat.mtime,
        "mode": stat.mode
      });
    } else if (FS.isFile(stat.mode)) {
      node.contents = MEMFS.getFileDataAsTypedArray(node);
      return callback(null, {
        "timestamp": stat.mtime,
        "mode": stat.mode,
        "contents": node.contents
      });
    } else {
      return callback(new Error("node type not supported"));
    }
  },
  storeLocalEntry: function storeLocalEntry(path, entry, callback) {
    try {
      if (FS.isDir(entry["mode"])) {
        FS.mkdirTree(path, entry["mode"]);
      } else if (FS.isFile(entry["mode"])) {
        FS.writeFile(path, entry["contents"], {
          canOwn: true
        });
      } else {
        return callback(new Error("node type not supported"));
      }
      FS.chmod(path, entry["mode"]);
      FS.utime(path, entry["timestamp"], entry["timestamp"]);
    } catch (e) {
      return callback(e);
    }
    callback(null);
  },
  removeLocalEntry: function removeLocalEntry(path, callback) {
    try {
      var stat = FS.stat(path);
      if (FS.isDir(stat.mode)) {
        FS.rmdir(path);
      } else if (FS.isFile(stat.mode)) {
        FS.unlink(path);
      }
    } catch (e) {
      return callback(e);
    }
    callback(null);
  },
  loadRemoteEntry: function loadRemoteEntry(store, path, callback) {
    var req = store.get(path);
    req.onsuccess = function (event) {
      return callback(null, event.target.result);
    };
    req.onerror = function (e) {
      callback(e.target.error);
      e.preventDefault();
    };
  },
  storeRemoteEntry: function storeRemoteEntry(store, path, entry, callback) {
    try {
      var req = store.put(entry, path);
    } catch (e) {
      callback(e);
      return;
    }
    req.onsuccess = function (event) {
      return callback();
    };
    req.onerror = function (e) {
      callback(e.target.error);
      e.preventDefault();
    };
  },
  removeRemoteEntry: function removeRemoteEntry(store, path, callback) {
    var req = store.delete(path);
    req.onsuccess = function (event) {
      return callback();
    };
    req.onerror = function (e) {
      callback(e.target.error);
      e.preventDefault();
    };
  },
  reconcile: function reconcile(src, dst, callback) {
    var total = 0;
    var create = [];
    Object.keys(src.entries).forEach(function (key) {
      var e = src.entries[key];
      var e2 = dst.entries[key];
      if (!e2 || e["timestamp"].getTime() != e2["timestamp"].getTime()) {
        create.push(key);
        total++;
      }
    });
    var remove = [];
    Object.keys(dst.entries).forEach(function (key) {
      if (!src.entries[key]) {
        remove.push(key);
        total++;
      }
    });
    if (!total) {
      return callback(null);
    }
    var errored = false;
    var db = src.type === "remote" ? src.db : dst.db;
    var transaction = db.transaction([IDBFS.DB_STORE_NAME], "readwrite");
    var store = transaction.objectStore(IDBFS.DB_STORE_NAME);
    function done(err) {
      if (err && !errored) {
        errored = true;
        return callback(err);
      }
    }
    transaction.onerror = transaction.onabort = function (e) {
      done(e.target.error);
      e.preventDefault();
    };
    transaction.oncomplete = function (e) {
      if (!errored) {
        callback(null);
      }
    };
    create.sort().forEach(function (path) {
      if (dst.type === "local") {
        IDBFS.loadRemoteEntry(store, path, function (err, entry) {
          if (err) return done(err);
          IDBFS.storeLocalEntry(path, entry, done);
        });
      } else {
        IDBFS.loadLocalEntry(path, function (err, entry) {
          if (err) return done(err);
          IDBFS.storeRemoteEntry(store, path, entry, done);
        });
      }
    });
    remove.sort().reverse().forEach(function (path) {
      if (dst.type === "local") {
        IDBFS.removeLocalEntry(path, done);
      } else {
        IDBFS.removeRemoteEntry(store, path, done);
      }
    });
  }
};
var FS = {
  root: null,
  mounts: [],
  devices: {},
  streams: [],
  nextInode: 1,
  nameTable: null,
  currentPath: "/",
  initialized: false,
  ignorePermissions: true,
  ErrnoError: /*#__PURE__*/_createClass(function ErrnoError(errno) {
    "use strict";

    _classCallCheck(this, ErrnoError);
    this.name = "ErrnoError";
    this.errno = errno;
  }),
  genericErrors: {},
  filesystems: null,
  syncFSRequests: 0,
  FSStream: /*#__PURE__*/function () {
    "use strict";

    function FSStream() {
      _classCallCheck(this, FSStream);
      this.shared = {};
    }
    _createClass(FSStream, [{
      key: "object",
      get: function get() {
        return this.node;
      },
      set: function set(val) {
        this.node = val;
      }
    }, {
      key: "isRead",
      get: function get() {
        return (this.flags & 2097155) !== 1;
      }
    }, {
      key: "isWrite",
      get: function get() {
        return (this.flags & 2097155) !== 0;
      }
    }, {
      key: "isAppend",
      get: function get() {
        return this.flags & 1024;
      }
    }, {
      key: "flags",
      get: function get() {
        return this.shared.flags;
      },
      set: function set(val) {
        this.shared.flags = val;
      }
    }, {
      key: "position",
      get: function get() {
        return this.shared.position;
      },
      set: function set(val) {
        this.shared.position = val;
      }
    }]);
    return FSStream;
  }(),
  FSNode: /*#__PURE__*/function () {
    "use strict";

    function FSNode(parent, name, mode, rdev) {
      _classCallCheck(this, FSNode);
      if (!parent) {
        parent = this;
      }
      this.parent = parent;
      this.mount = parent.mount;
      this.mounted = null;
      this.id = FS.nextInode++;
      this.name = name;
      this.mode = mode;
      this.node_ops = {};
      this.stream_ops = {};
      this.rdev = rdev;
      this.readMode = 292 | 73;
      this.writeMode = 146;
    }
    _createClass(FSNode, [{
      key: "read",
      get: function get() {
        return (this.mode & this.readMode) === this.readMode;
      },
      set: function set(val) {
        val ? this.mode |= this.readMode : this.mode &= ~this.readMode;
      }
    }, {
      key: "write",
      get: function get() {
        return (this.mode & this.writeMode) === this.writeMode;
      },
      set: function set(val) {
        val ? this.mode |= this.writeMode : this.mode &= ~this.writeMode;
      }
    }, {
      key: "isFolder",
      get: function get() {
        return FS.isDir(this.mode);
      }
    }, {
      key: "isDevice",
      get: function get() {
        return FS.isChrdev(this.mode);
      }
    }]);
    return FSNode;
  }(),
  lookupPath: function lookupPath(path) {
    var opts = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
    path = PATH_FS.resolve(path);
    if (!path) return {
      path: "",
      node: null
    };
    var defaults = {
      follow_mount: true,
      recurse_count: 0
    };
    opts = Object.assign(defaults, opts);
    if (opts.recurse_count > 8) {
      throw new FS.ErrnoError(32);
    }
    var parts = path.split("/").filter(function (p) {
      return !!p;
    });
    var current = FS.root;
    var current_path = "/";
    for (var i = 0; i < parts.length; i++) {
      var islast = i === parts.length - 1;
      if (islast && opts.parent) {
        break;
      }
      current = FS.lookupNode(current, parts[i]);
      current_path = PATH.join2(current_path, parts[i]);
      if (FS.isMountpoint(current)) {
        if (!islast || islast && opts.follow_mount) {
          current = current.mounted.root;
        }
      }
      if (!islast || opts.follow) {
        var count = 0;
        while (FS.isLink(current.mode)) {
          var link = FS.readlink(current_path);
          current_path = PATH_FS.resolve(PATH.dirname(current_path), link);
          var lookup = FS.lookupPath(current_path, {
            recurse_count: opts.recurse_count + 1
          });
          current = lookup.node;
          if (count++ > 40) {
            throw new FS.ErrnoError(32);
          }
        }
      }
    }
    return {
      path: current_path,
      node: current
    };
  },
  getPath: function getPath(node) {
    var path;
    while (true) {
      if (FS.isRoot(node)) {
        var mount = node.mount.mountpoint;
        if (!path) return mount;
        return mount[mount.length - 1] !== "/" ? "".concat(mount, "/").concat(path) : mount + path;
      }
      path = path ? "".concat(node.name, "/").concat(path) : node.name;
      node = node.parent;
    }
  },
  hashName: function hashName(parentid, name) {
    var hash = 0;
    for (var i = 0; i < name.length; i++) {
      hash = (hash << 5) - hash + name.charCodeAt(i) | 0;
    }
    return (parentid + hash >>> 0) % FS.nameTable.length;
  },
  hashAddNode: function hashAddNode(node) {
    var hash = FS.hashName(node.parent.id, node.name);
    node.name_next = FS.nameTable[hash];
    FS.nameTable[hash] = node;
  },
  hashRemoveNode: function hashRemoveNode(node) {
    var hash = FS.hashName(node.parent.id, node.name);
    if (FS.nameTable[hash] === node) {
      FS.nameTable[hash] = node.name_next;
    } else {
      var current = FS.nameTable[hash];
      while (current) {
        if (current.name_next === node) {
          current.name_next = node.name_next;
          break;
        }
        current = current.name_next;
      }
    }
  },
  lookupNode: function lookupNode(parent, name) {
    var errCode = FS.mayLookup(parent);
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    var hash = FS.hashName(parent.id, name);
    for (var node = FS.nameTable[hash]; node; node = node.name_next) {
      var nodeName = node.name;
      if (node.parent.id === parent.id && nodeName === name) {
        return node;
      }
    }
    return FS.lookup(parent, name);
  },
  createNode: function createNode(parent, name, mode, rdev) {
    var node = new FS.FSNode(parent, name, mode, rdev);
    FS.hashAddNode(node);
    return node;
  },
  destroyNode: function destroyNode(node) {
    FS.hashRemoveNode(node);
  },
  isRoot: function isRoot(node) {
    return node === node.parent;
  },
  isMountpoint: function isMountpoint(node) {
    return !!node.mounted;
  },
  isFile: function isFile(mode) {
    return (mode & 61440) === 32768;
  },
  isDir: function isDir(mode) {
    return (mode & 61440) === 16384;
  },
  isLink: function isLink(mode) {
    return (mode & 61440) === 40960;
  },
  isChrdev: function isChrdev(mode) {
    return (mode & 61440) === 8192;
  },
  isBlkdev: function isBlkdev(mode) {
    return (mode & 61440) === 24576;
  },
  isFIFO: function isFIFO(mode) {
    return (mode & 61440) === 4096;
  },
  isSocket: function isSocket(mode) {
    return (mode & 49152) === 49152;
  },
  flagsToPermissionString: function flagsToPermissionString(flag) {
    var perms = ["r", "w", "rw"][flag & 3];
    if (flag & 512) {
      perms += "w";
    }
    return perms;
  },
  nodePermissions: function nodePermissions(node, perms) {
    if (FS.ignorePermissions) {
      return 0;
    }
    if (perms.includes("r") && !(node.mode & 292)) {
      return 2;
    } else if (perms.includes("w") && !(node.mode & 146)) {
      return 2;
    } else if (perms.includes("x") && !(node.mode & 73)) {
      return 2;
    }
    return 0;
  },
  mayLookup: function mayLookup(dir) {
    if (!FS.isDir(dir.mode)) return 54;
    var errCode = FS.nodePermissions(dir, "x");
    if (errCode) return errCode;
    if (!dir.node_ops.lookup) return 2;
    return 0;
  },
  mayCreate: function mayCreate(dir, name) {
    try {
      var node = FS.lookupNode(dir, name);
      return 20;
    } catch (e) {}
    return FS.nodePermissions(dir, "wx");
  },
  mayDelete: function mayDelete(dir, name, isdir) {
    var node;
    try {
      node = FS.lookupNode(dir, name);
    } catch (e) {
      return e.errno;
    }
    var errCode = FS.nodePermissions(dir, "wx");
    if (errCode) {
      return errCode;
    }
    if (isdir) {
      if (!FS.isDir(node.mode)) {
        return 54;
      }
      if (FS.isRoot(node) || FS.getPath(node) === FS.cwd()) {
        return 10;
      }
    } else {
      if (FS.isDir(node.mode)) {
        return 31;
      }
    }
    return 0;
  },
  mayOpen: function mayOpen(node, flags) {
    if (!node) {
      return 44;
    }
    if (FS.isLink(node.mode)) {
      return 32;
    } else if (FS.isDir(node.mode)) {
      if (FS.flagsToPermissionString(flags) !== "r" || flags & 512) {
        return 31;
      }
    }
    return FS.nodePermissions(node, FS.flagsToPermissionString(flags));
  },
  MAX_OPEN_FDS: 4096,
  nextfd: function nextfd() {
    for (var fd = 0; fd <= FS.MAX_OPEN_FDS; fd++) {
      if (!FS.streams[fd]) {
        return fd;
      }
    }
    throw new FS.ErrnoError(33);
  },
  getStreamChecked: function getStreamChecked(fd) {
    var stream = FS.getStream(fd);
    if (!stream) {
      throw new FS.ErrnoError(8);
    }
    return stream;
  },
  getStream: function getStream(fd) {
    return FS.streams[fd];
  },
  createStream: function createStream(stream) {
    var fd = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : -1;
    stream = Object.assign(new FS.FSStream(), stream);
    if (fd == -1) {
      fd = FS.nextfd();
    }
    stream.fd = fd;
    FS.streams[fd] = stream;
    return stream;
  },
  closeStream: function closeStream(fd) {
    FS.streams[fd] = null;
  },
  dupStream: function dupStream(origStream) {
    var _stream$stream_ops, _stream$stream_ops$du;
    var fd = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : -1;
    var stream = FS.createStream(origStream, fd);
    (_stream$stream_ops = stream.stream_ops) === null || _stream$stream_ops === void 0 || (_stream$stream_ops$du = _stream$stream_ops.dup) === null || _stream$stream_ops$du === void 0 || _stream$stream_ops$du.call(_stream$stream_ops, stream);
    return stream;
  },
  chrdev_stream_ops: {
    open: function open(stream) {
      var _stream$stream_ops$op, _stream$stream_ops2;
      var device = FS.getDevice(stream.node.rdev);
      stream.stream_ops = device.stream_ops;
      (_stream$stream_ops$op = (_stream$stream_ops2 = stream.stream_ops).open) === null || _stream$stream_ops$op === void 0 || _stream$stream_ops$op.call(_stream$stream_ops2, stream);
    },
    llseek: function llseek() {
      throw new FS.ErrnoError(70);
    }
  },
  major: function major(dev) {
    return dev >> 8;
  },
  minor: function minor(dev) {
    return dev & 255;
  },
  makedev: function makedev(ma, mi) {
    return ma << 8 | mi;
  },
  registerDevice: function registerDevice(dev, ops) {
    FS.devices[dev] = {
      stream_ops: ops
    };
  },
  getDevice: function getDevice(dev) {
    return FS.devices[dev];
  },
  getMounts: function getMounts(mount) {
    var mounts = [];
    var check = [mount];
    while (check.length) {
      var m = check.pop();
      mounts.push(m);
      check.push.apply(check, _toConsumableArray(m.mounts));
    }
    return mounts;
  },
  syncfs: function syncfs(populate, callback) {
    if (typeof populate == "function") {
      callback = populate;
      populate = false;
    }
    FS.syncFSRequests++;
    if (FS.syncFSRequests > 1) {
      err("warning: ".concat(FS.syncFSRequests, " FS.syncfs operations in flight at once, probably just doing extra work"));
    }
    var mounts = FS.getMounts(FS.root.mount);
    var completed = 0;
    function doCallback(errCode) {
      FS.syncFSRequests--;
      return callback(errCode);
    }
    function done(errCode) {
      if (errCode) {
        if (!done.errored) {
          done.errored = true;
          return doCallback(errCode);
        }
        return;
      }
      if (++completed >= mounts.length) {
        doCallback(null);
      }
    }
    mounts.forEach(function (mount) {
      if (!mount.type.syncfs) {
        return done(null);
      }
      mount.type.syncfs(mount, populate, done);
    });
  },
  mount: function mount(type, opts, mountpoint) {
    var root = mountpoint === "/";
    var pseudo = !mountpoint;
    var node;
    if (root && FS.root) {
      throw new FS.ErrnoError(10);
    } else if (!root && !pseudo) {
      var lookup = FS.lookupPath(mountpoint, {
        follow_mount: false
      });
      mountpoint = lookup.path;
      node = lookup.node;
      if (FS.isMountpoint(node)) {
        throw new FS.ErrnoError(10);
      }
      if (!FS.isDir(node.mode)) {
        throw new FS.ErrnoError(54);
      }
    }
    var mount = {
      type: type,
      opts: opts,
      mountpoint: mountpoint,
      mounts: []
    };
    var mountRoot = type.mount(mount);
    mountRoot.mount = mount;
    mount.root = mountRoot;
    if (root) {
      FS.root = mountRoot;
    } else if (node) {
      node.mounted = mount;
      if (node.mount) {
        node.mount.mounts.push(mount);
      }
    }
    return mountRoot;
  },
  unmount: function unmount(mountpoint) {
    var lookup = FS.lookupPath(mountpoint, {
      follow_mount: false
    });
    if (!FS.isMountpoint(lookup.node)) {
      throw new FS.ErrnoError(28);
    }
    var node = lookup.node;
    var mount = node.mounted;
    var mounts = FS.getMounts(mount);
    Object.keys(FS.nameTable).forEach(function (hash) {
      var current = FS.nameTable[hash];
      while (current) {
        var next = current.name_next;
        if (mounts.includes(current.mount)) {
          FS.destroyNode(current);
        }
        current = next;
      }
    });
    node.mounted = null;
    var idx = node.mount.mounts.indexOf(mount);
    node.mount.mounts.splice(idx, 1);
  },
  lookup: function lookup(parent, name) {
    return parent.node_ops.lookup(parent, name);
  },
  mknod: function mknod(path, mode, dev) {
    var lookup = FS.lookupPath(path, {
      parent: true
    });
    var parent = lookup.node;
    var name = PATH.basename(path);
    if (!name || name === "." || name === "..") {
      throw new FS.ErrnoError(28);
    }
    var errCode = FS.mayCreate(parent, name);
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    if (!parent.node_ops.mknod) {
      throw new FS.ErrnoError(63);
    }
    return parent.node_ops.mknod(parent, name, mode, dev);
  },
  create: function create(path, mode) {
    mode = mode !== undefined ? mode : 438;
    mode &= 4095;
    mode |= 32768;
    return FS.mknod(path, mode, 0);
  },
  mkdir: function mkdir(path, mode) {
    mode = mode !== undefined ? mode : 511;
    mode &= 511 | 512;
    mode |= 16384;
    return FS.mknod(path, mode, 0);
  },
  mkdirTree: function mkdirTree(path, mode) {
    var dirs = path.split("/");
    var d = "";
    for (var i = 0; i < dirs.length; ++i) {
      if (!dirs[i]) continue;
      d += "/" + dirs[i];
      try {
        FS.mkdir(d, mode);
      } catch (e) {
        if (e.errno != 20) throw e;
      }
    }
  },
  mkdev: function mkdev(path, mode, dev) {
    if (typeof dev == "undefined") {
      dev = mode;
      mode = 438;
    }
    mode |= 8192;
    return FS.mknod(path, mode, dev);
  },
  symlink: function symlink(oldpath, newpath) {
    if (!PATH_FS.resolve(oldpath)) {
      throw new FS.ErrnoError(44);
    }
    var lookup = FS.lookupPath(newpath, {
      parent: true
    });
    var parent = lookup.node;
    if (!parent) {
      throw new FS.ErrnoError(44);
    }
    var newname = PATH.basename(newpath);
    var errCode = FS.mayCreate(parent, newname);
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    if (!parent.node_ops.symlink) {
      throw new FS.ErrnoError(63);
    }
    return parent.node_ops.symlink(parent, newname, oldpath);
  },
  rename: function rename(old_path, new_path) {
    var old_dirname = PATH.dirname(old_path);
    var new_dirname = PATH.dirname(new_path);
    var old_name = PATH.basename(old_path);
    var new_name = PATH.basename(new_path);
    var lookup, old_dir, new_dir;
    lookup = FS.lookupPath(old_path, {
      parent: true
    });
    old_dir = lookup.node;
    lookup = FS.lookupPath(new_path, {
      parent: true
    });
    new_dir = lookup.node;
    if (!old_dir || !new_dir) throw new FS.ErrnoError(44);
    if (old_dir.mount !== new_dir.mount) {
      throw new FS.ErrnoError(75);
    }
    var old_node = FS.lookupNode(old_dir, old_name);
    var relative = PATH_FS.relative(old_path, new_dirname);
    if (relative.charAt(0) !== ".") {
      throw new FS.ErrnoError(28);
    }
    relative = PATH_FS.relative(new_path, old_dirname);
    if (relative.charAt(0) !== ".") {
      throw new FS.ErrnoError(55);
    }
    var new_node;
    try {
      new_node = FS.lookupNode(new_dir, new_name);
    } catch (e) {}
    if (old_node === new_node) {
      return;
    }
    var isdir = FS.isDir(old_node.mode);
    var errCode = FS.mayDelete(old_dir, old_name, isdir);
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    errCode = new_node ? FS.mayDelete(new_dir, new_name, isdir) : FS.mayCreate(new_dir, new_name);
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    if (!old_dir.node_ops.rename) {
      throw new FS.ErrnoError(63);
    }
    if (FS.isMountpoint(old_node) || new_node && FS.isMountpoint(new_node)) {
      throw new FS.ErrnoError(10);
    }
    if (new_dir !== old_dir) {
      errCode = FS.nodePermissions(old_dir, "w");
      if (errCode) {
        throw new FS.ErrnoError(errCode);
      }
    }
    FS.hashRemoveNode(old_node);
    try {
      old_dir.node_ops.rename(old_node, new_dir, new_name);
    } catch (e) {
      throw e;
    } finally {
      FS.hashAddNode(old_node);
    }
  },
  rmdir: function rmdir(path) {
    var lookup = FS.lookupPath(path, {
      parent: true
    });
    var parent = lookup.node;
    var name = PATH.basename(path);
    var node = FS.lookupNode(parent, name);
    var errCode = FS.mayDelete(parent, name, true);
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    if (!parent.node_ops.rmdir) {
      throw new FS.ErrnoError(63);
    }
    if (FS.isMountpoint(node)) {
      throw new FS.ErrnoError(10);
    }
    parent.node_ops.rmdir(parent, name);
    FS.destroyNode(node);
  },
  readdir: function readdir(path) {
    var lookup = FS.lookupPath(path, {
      follow: true
    });
    var node = lookup.node;
    if (!node.node_ops.readdir) {
      throw new FS.ErrnoError(54);
    }
    return node.node_ops.readdir(node);
  },
  unlink: function unlink(path) {
    var lookup = FS.lookupPath(path, {
      parent: true
    });
    var parent = lookup.node;
    if (!parent) {
      throw new FS.ErrnoError(44);
    }
    var name = PATH.basename(path);
    var node = FS.lookupNode(parent, name);
    var errCode = FS.mayDelete(parent, name, false);
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    if (!parent.node_ops.unlink) {
      throw new FS.ErrnoError(63);
    }
    if (FS.isMountpoint(node)) {
      throw new FS.ErrnoError(10);
    }
    parent.node_ops.unlink(parent, name);
    FS.destroyNode(node);
  },
  readlink: function readlink(path) {
    var lookup = FS.lookupPath(path);
    var link = lookup.node;
    if (!link) {
      throw new FS.ErrnoError(44);
    }
    if (!link.node_ops.readlink) {
      throw new FS.ErrnoError(28);
    }
    return PATH_FS.resolve(FS.getPath(link.parent), link.node_ops.readlink(link));
  },
  stat: function stat(path, dontFollow) {
    var lookup = FS.lookupPath(path, {
      follow: !dontFollow
    });
    var node = lookup.node;
    if (!node) {
      throw new FS.ErrnoError(44);
    }
    if (!node.node_ops.getattr) {
      throw new FS.ErrnoError(63);
    }
    return node.node_ops.getattr(node);
  },
  lstat: function lstat(path) {
    return FS.stat(path, true);
  },
  chmod: function chmod(path, mode, dontFollow) {
    var node;
    if (typeof path == "string") {
      var lookup = FS.lookupPath(path, {
        follow: !dontFollow
      });
      node = lookup.node;
    } else {
      node = path;
    }
    if (!node.node_ops.setattr) {
      throw new FS.ErrnoError(63);
    }
    node.node_ops.setattr(node, {
      mode: mode & 4095 | node.mode & ~4095,
      timestamp: Date.now()
    });
  },
  lchmod: function lchmod(path, mode) {
    FS.chmod(path, mode, true);
  },
  fchmod: function fchmod(fd, mode) {
    var stream = FS.getStreamChecked(fd);
    FS.chmod(stream.node, mode);
  },
  chown: function chown(path, uid, gid, dontFollow) {
    var node;
    if (typeof path == "string") {
      var lookup = FS.lookupPath(path, {
        follow: !dontFollow
      });
      node = lookup.node;
    } else {
      node = path;
    }
    if (!node.node_ops.setattr) {
      throw new FS.ErrnoError(63);
    }
    node.node_ops.setattr(node, {
      timestamp: Date.now()
    });
  },
  lchown: function lchown(path, uid, gid) {
    FS.chown(path, uid, gid, true);
  },
  fchown: function fchown(fd, uid, gid) {
    var stream = FS.getStreamChecked(fd);
    FS.chown(stream.node, uid, gid);
  },
  truncate: function truncate(path, len) {
    if (len < 0) {
      throw new FS.ErrnoError(28);
    }
    var node;
    if (typeof path == "string") {
      var lookup = FS.lookupPath(path, {
        follow: true
      });
      node = lookup.node;
    } else {
      node = path;
    }
    if (!node.node_ops.setattr) {
      throw new FS.ErrnoError(63);
    }
    if (FS.isDir(node.mode)) {
      throw new FS.ErrnoError(31);
    }
    if (!FS.isFile(node.mode)) {
      throw new FS.ErrnoError(28);
    }
    var errCode = FS.nodePermissions(node, "w");
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    node.node_ops.setattr(node, {
      size: len,
      timestamp: Date.now()
    });
  },
  ftruncate: function ftruncate(fd, len) {
    var stream = FS.getStreamChecked(fd);
    if ((stream.flags & 2097155) === 0) {
      throw new FS.ErrnoError(28);
    }
    FS.truncate(stream.node, len);
  },
  utime: function utime(path, atime, mtime) {
    var lookup = FS.lookupPath(path, {
      follow: true
    });
    var node = lookup.node;
    node.node_ops.setattr(node, {
      timestamp: Math.max(atime, mtime)
    });
  },
  open: function open(path, flags, mode) {
    if (path === "") {
      throw new FS.ErrnoError(44);
    }
    flags = typeof flags == "string" ? FS_modeStringToFlags(flags) : flags;
    mode = typeof mode == "undefined" ? 438 : mode;
    if (flags & 64) {
      mode = mode & 4095 | 32768;
    } else {
      mode = 0;
    }
    var node;
    if (_typeof(path) == "object") {
      node = path;
    } else {
      path = PATH.normalize(path);
      try {
        var lookup = FS.lookupPath(path, {
          follow: !(flags & 131072)
        });
        node = lookup.node;
      } catch (e) {}
    }
    var created = false;
    if (flags & 64) {
      if (node) {
        if (flags & 128) {
          throw new FS.ErrnoError(20);
        }
      } else {
        node = FS.mknod(path, mode, 0);
        created = true;
      }
    }
    if (!node) {
      throw new FS.ErrnoError(44);
    }
    if (FS.isChrdev(node.mode)) {
      flags &= ~512;
    }
    if (flags & 65536 && !FS.isDir(node.mode)) {
      throw new FS.ErrnoError(54);
    }
    if (!created) {
      var errCode = FS.mayOpen(node, flags);
      if (errCode) {
        throw new FS.ErrnoError(errCode);
      }
    }
    if (flags & 512 && !created) {
      FS.truncate(node, 0);
    }
    flags &= ~(128 | 512 | 131072);
    var stream = FS.createStream({
      node: node,
      path: FS.getPath(node),
      flags: flags,
      seekable: true,
      position: 0,
      stream_ops: node.stream_ops,
      ungotten: [],
      error: false
    });
    if (stream.stream_ops.open) {
      stream.stream_ops.open(stream);
    }
    if (Module["logReadFiles"] && !(flags & 1)) {
      if (!FS.readFiles) FS.readFiles = {};
      if (!(path in FS.readFiles)) {
        FS.readFiles[path] = 1;
      }
    }
    return stream;
  },
  close: function close(stream) {
    if (FS.isClosed(stream)) {
      throw new FS.ErrnoError(8);
    }
    if (stream.getdents) stream.getdents = null;
    try {
      if (stream.stream_ops.close) {
        stream.stream_ops.close(stream);
      }
    } catch (e) {
      throw e;
    } finally {
      FS.closeStream(stream.fd);
    }
    stream.fd = null;
  },
  isClosed: function isClosed(stream) {
    return stream.fd === null;
  },
  llseek: function llseek(stream, offset, whence) {
    if (FS.isClosed(stream)) {
      throw new FS.ErrnoError(8);
    }
    if (!stream.seekable || !stream.stream_ops.llseek) {
      throw new FS.ErrnoError(70);
    }
    if (whence != 0 && whence != 1 && whence != 2) {
      throw new FS.ErrnoError(28);
    }
    stream.position = stream.stream_ops.llseek(stream, offset, whence);
    stream.ungotten = [];
    return stream.position;
  },
  read: function read(stream, buffer, offset, length, position) {
    if (length < 0 || position < 0) {
      throw new FS.ErrnoError(28);
    }
    if (FS.isClosed(stream)) {
      throw new FS.ErrnoError(8);
    }
    if ((stream.flags & 2097155) === 1) {
      throw new FS.ErrnoError(8);
    }
    if (FS.isDir(stream.node.mode)) {
      throw new FS.ErrnoError(31);
    }
    if (!stream.stream_ops.read) {
      throw new FS.ErrnoError(28);
    }
    var seeking = typeof position != "undefined";
    if (!seeking) {
      position = stream.position;
    } else if (!stream.seekable) {
      throw new FS.ErrnoError(70);
    }
    var bytesRead = stream.stream_ops.read(stream, buffer, offset, length, position);
    if (!seeking) stream.position += bytesRead;
    return bytesRead;
  },
  write: function write(stream, buffer, offset, length, position, canOwn) {
    if (length < 0 || position < 0) {
      throw new FS.ErrnoError(28);
    }
    if (FS.isClosed(stream)) {
      throw new FS.ErrnoError(8);
    }
    if ((stream.flags & 2097155) === 0) {
      throw new FS.ErrnoError(8);
    }
    if (FS.isDir(stream.node.mode)) {
      throw new FS.ErrnoError(31);
    }
    if (!stream.stream_ops.write) {
      throw new FS.ErrnoError(28);
    }
    if (stream.seekable && stream.flags & 1024) {
      FS.llseek(stream, 0, 2);
    }
    var seeking = typeof position != "undefined";
    if (!seeking) {
      position = stream.position;
    } else if (!stream.seekable) {
      throw new FS.ErrnoError(70);
    }
    var bytesWritten = stream.stream_ops.write(stream, buffer, offset, length, position, canOwn);
    if (!seeking) stream.position += bytesWritten;
    return bytesWritten;
  },
  allocate: function allocate(stream, offset, length) {
    if (FS.isClosed(stream)) {
      throw new FS.ErrnoError(8);
    }
    if (offset < 0 || length <= 0) {
      throw new FS.ErrnoError(28);
    }
    if ((stream.flags & 2097155) === 0) {
      throw new FS.ErrnoError(8);
    }
    if (!FS.isFile(stream.node.mode) && !FS.isDir(stream.node.mode)) {
      throw new FS.ErrnoError(43);
    }
    if (!stream.stream_ops.allocate) {
      throw new FS.ErrnoError(138);
    }
    stream.stream_ops.allocate(stream, offset, length);
  },
  mmap: function mmap(stream, length, position, prot, flags) {
    if ((prot & 2) !== 0 && (flags & 2) === 0 && (stream.flags & 2097155) !== 2) {
      throw new FS.ErrnoError(2);
    }
    if ((stream.flags & 2097155) === 1) {
      throw new FS.ErrnoError(2);
    }
    if (!stream.stream_ops.mmap) {
      throw new FS.ErrnoError(43);
    }
    return stream.stream_ops.mmap(stream, length, position, prot, flags);
  },
  msync: function msync(stream, buffer, offset, length, mmapFlags) {
    if (!stream.stream_ops.msync) {
      return 0;
    }
    return stream.stream_ops.msync(stream, buffer, offset, length, mmapFlags);
  },
  ioctl: function ioctl(stream, cmd, arg) {
    if (!stream.stream_ops.ioctl) {
      throw new FS.ErrnoError(59);
    }
    return stream.stream_ops.ioctl(stream, cmd, arg);
  },
  readFile: function readFile(path) {
    var opts = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {};
    opts.flags = opts.flags || 0;
    opts.encoding = opts.encoding || "binary";
    if (opts.encoding !== "utf8" && opts.encoding !== "binary") {
      throw new Error("Invalid encoding type \"".concat(opts.encoding, "\""));
    }
    var ret;
    var stream = FS.open(path, opts.flags);
    var stat = FS.stat(path);
    var length = stat.size;
    var buf = new Uint8Array(length);
    FS.read(stream, buf, 0, length, 0);
    if (opts.encoding === "utf8") {
      ret = UTF8ArrayToString(buf, 0);
    } else if (opts.encoding === "binary") {
      ret = buf;
    }
    FS.close(stream);
    return ret;
  },
  writeFile: function writeFile(path, data) {
    var opts = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : {};
    opts.flags = opts.flags || 577;
    var stream = FS.open(path, opts.flags, opts.mode);
    if (typeof data == "string") {
      var buf = new Uint8Array(lengthBytesUTF8(data) + 1);
      var actualNumBytes = stringToUTF8Array(data, buf, 0, buf.length);
      FS.write(stream, buf, 0, actualNumBytes, undefined, opts.canOwn);
    } else if (ArrayBuffer.isView(data)) {
      FS.write(stream, data, 0, data.byteLength, undefined, opts.canOwn);
    } else {
      throw new Error("Unsupported data type");
    }
    FS.close(stream);
  },
  cwd: function cwd() {
    return FS.currentPath;
  },
  chdir: function chdir(path) {
    var lookup = FS.lookupPath(path, {
      follow: true
    });
    if (lookup.node === null) {
      throw new FS.ErrnoError(44);
    }
    if (!FS.isDir(lookup.node.mode)) {
      throw new FS.ErrnoError(54);
    }
    var errCode = FS.nodePermissions(lookup.node, "x");
    if (errCode) {
      throw new FS.ErrnoError(errCode);
    }
    FS.currentPath = lookup.path;
  },
  createDefaultDirectories: function createDefaultDirectories() {
    FS.mkdir("/tmp");
    FS.mkdir("/home");
    FS.mkdir("/home/web_user");
  },
  createDefaultDevices: function createDefaultDevices() {
    FS.mkdir("/dev");
    FS.registerDevice(FS.makedev(1, 3), {
      read: function read() {
        return 0;
      },
      write: function write(stream, buffer, offset, length, pos) {
        return length;
      }
    });
    FS.mkdev("/dev/null", FS.makedev(1, 3));
    TTY.register(FS.makedev(5, 0), TTY.default_tty_ops);
    TTY.register(FS.makedev(6, 0), TTY.default_tty1_ops);
    FS.mkdev("/dev/tty", FS.makedev(5, 0));
    FS.mkdev("/dev/tty1", FS.makedev(6, 0));
    var randomBuffer = new Uint8Array(1024),
      randomLeft = 0;
    var randomByte = function randomByte() {
      if (randomLeft === 0) {
        randomLeft = _randomFill(randomBuffer).byteLength;
      }
      return randomBuffer[--randomLeft];
    };
    FS.createDevice("/dev", "random", randomByte);
    FS.createDevice("/dev", "urandom", randomByte);
    FS.mkdir("/dev/shm");
    FS.mkdir("/dev/shm/tmp");
  },
  createSpecialDirectories: function createSpecialDirectories() {
    FS.mkdir("/proc");
    var proc_self = FS.mkdir("/proc/self");
    FS.mkdir("/proc/self/fd");
    FS.mount({
      mount: function mount() {
        var node = FS.createNode(proc_self, "fd", 16384 | 511, 73);
        node.node_ops = {
          lookup: function lookup(parent, name) {
            var fd = +name;
            var stream = FS.getStreamChecked(fd);
            var ret = {
              parent: null,
              mount: {
                mountpoint: "fake"
              },
              node_ops: {
                readlink: function readlink() {
                  return stream.path;
                }
              }
            };
            ret.parent = ret;
            return ret;
          }
        };
        return node;
      }
    }, {}, "/proc/self/fd");
  },
  createStandardStreams: function createStandardStreams() {
    if (Module["stdin"]) {
      FS.createDevice("/dev", "stdin", Module["stdin"]);
    } else {
      FS.symlink("/dev/tty", "/dev/stdin");
    }
    if (Module["stdout"]) {
      FS.createDevice("/dev", "stdout", null, Module["stdout"]);
    } else {
      FS.symlink("/dev/tty", "/dev/stdout");
    }
    if (Module["stderr"]) {
      FS.createDevice("/dev", "stderr", null, Module["stderr"]);
    } else {
      FS.symlink("/dev/tty1", "/dev/stderr");
    }
    var stdin = FS.open("/dev/stdin", 0);
    var stdout = FS.open("/dev/stdout", 1);
    var stderr = FS.open("/dev/stderr", 1);
  },
  staticInit: function staticInit() {
    [44].forEach(function (code) {
      FS.genericErrors[code] = new FS.ErrnoError(code);
      FS.genericErrors[code].stack = "<generic error, no stack>";
    });
    FS.nameTable = new Array(4096);
    FS.mount(MEMFS, {}, "/");
    FS.createDefaultDirectories();
    FS.createDefaultDevices();
    FS.createSpecialDirectories();
    FS.filesystems = {
      "MEMFS": MEMFS,
      "IDBFS": IDBFS
    };
  },
  init: function init(input, output, error) {
    FS.init.initialized = true;
    Module["stdin"] = input || Module["stdin"];
    Module["stdout"] = output || Module["stdout"];
    Module["stderr"] = error || Module["stderr"];
    FS.createStandardStreams();
  },
  quit: function quit() {
    FS.init.initialized = false;
    for (var i = 0; i < FS.streams.length; i++) {
      var stream = FS.streams[i];
      if (!stream) {
        continue;
      }
      FS.close(stream);
    }
  },
  findObject: function findObject(path, dontResolveLastLink) {
    var ret = FS.analyzePath(path, dontResolveLastLink);
    if (!ret.exists) {
      return null;
    }
    return ret.object;
  },
  analyzePath: function analyzePath(path, dontResolveLastLink) {
    try {
      var lookup = FS.lookupPath(path, {
        follow: !dontResolveLastLink
      });
      path = lookup.path;
    } catch (e) {}
    var ret = {
      isRoot: false,
      exists: false,
      error: 0,
      name: null,
      path: null,
      object: null,
      parentExists: false,
      parentPath: null,
      parentObject: null
    };
    try {
      var lookup = FS.lookupPath(path, {
        parent: true
      });
      ret.parentExists = true;
      ret.parentPath = lookup.path;
      ret.parentObject = lookup.node;
      ret.name = PATH.basename(path);
      lookup = FS.lookupPath(path, {
        follow: !dontResolveLastLink
      });
      ret.exists = true;
      ret.path = lookup.path;
      ret.object = lookup.node;
      ret.name = lookup.node.name;
      ret.isRoot = lookup.path === "/";
    } catch (e) {
      ret.error = e.errno;
    }
    return ret;
  },
  createPath: function createPath(parent, path, canRead, canWrite) {
    parent = typeof parent == "string" ? parent : FS.getPath(parent);
    var parts = path.split("/").reverse();
    while (parts.length) {
      var part = parts.pop();
      if (!part) continue;
      var current = PATH.join2(parent, part);
      try {
        FS.mkdir(current);
      } catch (e) {}
      parent = current;
    }
    return current;
  },
  createFile: function createFile(parent, name, properties, canRead, canWrite) {
    var path = PATH.join2(typeof parent == "string" ? parent : FS.getPath(parent), name);
    var mode = FS_getMode(canRead, canWrite);
    return FS.create(path, mode);
  },
  createDataFile: function createDataFile(parent, name, data, canRead, canWrite, canOwn) {
    var path = name;
    if (parent) {
      parent = typeof parent == "string" ? parent : FS.getPath(parent);
      path = name ? PATH.join2(parent, name) : parent;
    }
    var mode = FS_getMode(canRead, canWrite);
    var node = FS.create(path, mode);
    if (data) {
      if (typeof data == "string") {
        var arr = new Array(data.length);
        for (var i = 0, len = data.length; i < len; ++i) arr[i] = data.charCodeAt(i);
        data = arr;
      }
      FS.chmod(node, mode | 146);
      var stream = FS.open(node, 577);
      FS.write(stream, data, 0, data.length, 0, canOwn);
      FS.close(stream);
      FS.chmod(node, mode);
    }
  },
  createDevice: function createDevice(parent, name, input, output) {
    var path = PATH.join2(typeof parent == "string" ? parent : FS.getPath(parent), name);
    var mode = FS_getMode(!!input, !!output);
    if (!FS.createDevice.major) FS.createDevice.major = 64;
    var dev = FS.makedev(FS.createDevice.major++, 0);
    FS.registerDevice(dev, {
      open: function open(stream) {
        stream.seekable = false;
      },
      close: function close(stream) {
        var _output$buffer;
        if (output !== null && output !== void 0 && (_output$buffer = output.buffer) !== null && _output$buffer !== void 0 && _output$buffer.length) {
          output(10);
        }
      },
      read: function read(stream, buffer, offset, length, pos) {
        var bytesRead = 0;
        for (var i = 0; i < length; i++) {
          var result;
          try {
            result = input();
          } catch (e) {
            throw new FS.ErrnoError(29);
          }
          if (result === undefined && bytesRead === 0) {
            throw new FS.ErrnoError(6);
          }
          if (result === null || result === undefined) break;
          bytesRead++;
          buffer[offset + i] = result;
        }
        if (bytesRead) {
          stream.node.timestamp = Date.now();
        }
        return bytesRead;
      },
      write: function write(stream, buffer, offset, length, pos) {
        for (var i = 0; i < length; i++) {
          try {
            output(buffer[offset + i]);
          } catch (e) {
            throw new FS.ErrnoError(29);
          }
        }
        if (length) {
          stream.node.timestamp = Date.now();
        }
        return i;
      }
    });
    return FS.mkdev(path, mode, dev);
  },
  forceLoadFile: function forceLoadFile(obj) {
    if (obj.isDevice || obj.isFolder || obj.link || obj.contents) return true;
    if (typeof XMLHttpRequest != "undefined") {
      throw new Error("Lazy loading should have been performed (contents set) in createLazyFile, but it was not. Lazy loading only works in web workers. Use --embed-file or --preload-file in emcc on the main thread.");
    } else if (read_) {
      try {
        obj.contents = intArrayFromString(read_(obj.url), true);
        obj.usedBytes = obj.contents.length;
      } catch (e) {
        throw new FS.ErrnoError(29);
      }
    } else {
      throw new Error("Cannot load without read() or XMLHttpRequest.");
    }
  },
  createLazyFile: function createLazyFile(parent, name, url, canRead, canWrite) {
    var LazyUint8Array = /*#__PURE__*/function () {
      "use strict";

      function LazyUint8Array() {
        _classCallCheck(this, LazyUint8Array);
        this.lengthKnown = false;
        this.chunks = [];
      }
      _createClass(LazyUint8Array, [{
        key: "get",
        value: function get(idx) {
          if (idx > this.length - 1 || idx < 0) {
            return undefined;
          }
          var chunkOffset = idx % this.chunkSize;
          var chunkNum = idx / this.chunkSize | 0;
          return this.getter(chunkNum)[chunkOffset];
        }
      }, {
        key: "setDataGetter",
        value: function setDataGetter(getter) {
          this.getter = getter;
        }
      }, {
        key: "cacheLength",
        value: function cacheLength() {
          var xhr = new XMLHttpRequest();
          xhr.open("HEAD", url, false);
          xhr.send(null);
          if (!(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304)) throw new Error("Couldn't load " + url + ". Status: " + xhr.status);
          var datalength = Number(xhr.getResponseHeader("Content-length"));
          var header;
          var hasByteServing = (header = xhr.getResponseHeader("Accept-Ranges")) && header === "bytes";
          var usesGzip = (header = xhr.getResponseHeader("Content-Encoding")) && header === "gzip";
          var chunkSize = 1024 * 1024;
          if (!hasByteServing) chunkSize = datalength;
          var doXHR = function doXHR(from, to) {
            if (from > to) throw new Error("invalid range (" + from + ", " + to + ") or no bytes requested!");
            if (to > datalength - 1) throw new Error("only " + datalength + " bytes available! programmer error!");
            var xhr = new XMLHttpRequest();
            xhr.open("GET", url, false);
            if (datalength !== chunkSize) xhr.setRequestHeader("Range", "bytes=" + from + "-" + to);
            xhr.responseType = "arraybuffer";
            if (xhr.overrideMimeType) {
              xhr.overrideMimeType("text/plain; charset=x-user-defined");
            }
            xhr.send(null);
            if (!(xhr.status >= 200 && xhr.status < 300 || xhr.status === 304)) throw new Error("Couldn't load " + url + ". Status: " + xhr.status);
            if (xhr.response !== undefined) {
              return new Uint8Array(xhr.response || []);
            }
            return intArrayFromString(xhr.responseText || "", true);
          };
          var lazyArray = this;
          lazyArray.setDataGetter(function (chunkNum) {
            var start = chunkNum * chunkSize;
            var end = (chunkNum + 1) * chunkSize - 1;
            end = Math.min(end, datalength - 1);
            if (typeof lazyArray.chunks[chunkNum] == "undefined") {
              lazyArray.chunks[chunkNum] = doXHR(start, end);
            }
            if (typeof lazyArray.chunks[chunkNum] == "undefined") throw new Error("doXHR failed!");
            return lazyArray.chunks[chunkNum];
          });
          if (usesGzip || !datalength) {
            chunkSize = datalength = 1;
            datalength = this.getter(0).length;
            chunkSize = datalength;
            out("LazyFiles on gzip forces download of the whole file when length is accessed");
          }
          this._length = datalength;
          this._chunkSize = chunkSize;
          this.lengthKnown = true;
        }
      }, {
        key: "length",
        get: function get() {
          if (!this.lengthKnown) {
            this.cacheLength();
          }
          return this._length;
        }
      }, {
        key: "chunkSize",
        get: function get() {
          if (!this.lengthKnown) {
            this.cacheLength();
          }
          return this._chunkSize;
        }
      }]);
      return LazyUint8Array;
    }();
    if (typeof XMLHttpRequest != "undefined") {
      if (!ENVIRONMENT_IS_WORKER) throw "Cannot do synchronous binary XHRs outside webworkers in modern browsers. Use --embed-file or --preload-file in emcc";
      var lazyArray = new LazyUint8Array();
      var properties = {
        isDevice: false,
        contents: lazyArray
      };
    } else {
      var properties = {
        isDevice: false,
        url: url
      };
    }
    var node = FS.createFile(parent, name, properties, canRead, canWrite);
    if (properties.contents) {
      node.contents = properties.contents;
    } else if (properties.url) {
      node.contents = null;
      node.url = properties.url;
    }
    Object.defineProperties(node, {
      usedBytes: {
        get: function get() {
          return this.contents.length;
        }
      }
    });
    var stream_ops = {};
    var keys = Object.keys(node.stream_ops);
    keys.forEach(function (key) {
      var fn = node.stream_ops[key];
      stream_ops[key] = function () {
        FS.forceLoadFile(node);
        return fn.apply(void 0, arguments);
      };
    });
    function writeChunks(stream, buffer, offset, length, position) {
      var contents = stream.node.contents;
      if (position >= contents.length) return 0;
      var size = Math.min(contents.length - position, length);
      if (contents.slice) {
        for (var i = 0; i < size; i++) {
          buffer[offset + i] = contents[position + i];
        }
      } else {
        for (var i = 0; i < size; i++) {
          buffer[offset + i] = contents.get(position + i);
        }
      }
      return size;
    }
    stream_ops.read = function (stream, buffer, offset, length, position) {
      FS.forceLoadFile(node);
      return writeChunks(stream, buffer, offset, length, position);
    };
    stream_ops.mmap = function (stream, length, position, prot, flags) {
      FS.forceLoadFile(node);
      var ptr = mmapAlloc(length);
      if (!ptr) {
        throw new FS.ErrnoError(48);
      }
      writeChunks(stream, HEAP8, ptr, length, position);
      return {
        ptr: ptr,
        allocated: true
      };
    };
    node.stream_ops = stream_ops;
    return node;
  }
};
var SYSCALLS = {
  DEFAULT_POLLMASK: 5,
  calculateAt: function calculateAt(dirfd, path, allowEmpty) {
    if (PATH.isAbs(path)) {
      return path;
    }
    var dir;
    if (dirfd === -100) {
      dir = FS.cwd();
    } else {
      var dirstream = SYSCALLS.getStreamFromFD(dirfd);
      dir = dirstream.path;
    }
    if (path.length == 0) {
      if (!allowEmpty) {
        throw new FS.ErrnoError(44);
      }
      return dir;
    }
    return PATH.join2(dir, path);
  },
  doStat: function doStat(func, path, buf) {
    var stat = func(path);
    HEAP32[buf >> 2] = stat.dev;
    HEAP32[buf + 4 >> 2] = stat.mode;
    HEAPU32[buf + 8 >> 2] = stat.nlink;
    HEAP32[buf + 12 >> 2] = stat.uid;
    HEAP32[buf + 16 >> 2] = stat.gid;
    HEAP32[buf + 20 >> 2] = stat.rdev;
    tempI64 = [stat.size >>> 0, (tempDouble = stat.size, +Math.abs(tempDouble) >= 1 ? tempDouble > 0 ? +Math.floor(tempDouble / 4294967296) >>> 0 : ~~+Math.ceil((tempDouble - +(~~tempDouble >>> 0)) / 4294967296) >>> 0 : 0)], HEAP32[buf + 24 >> 2] = tempI64[0], HEAP32[buf + 28 >> 2] = tempI64[1];
    HEAP32[buf + 32 >> 2] = 4096;
    HEAP32[buf + 36 >> 2] = stat.blocks;
    var atime = stat.atime.getTime();
    var mtime = stat.mtime.getTime();
    var ctime = stat.ctime.getTime();
    tempI64 = [Math.floor(atime / 1e3) >>> 0, (tempDouble = Math.floor(atime / 1e3), +Math.abs(tempDouble) >= 1 ? tempDouble > 0 ? +Math.floor(tempDouble / 4294967296) >>> 0 : ~~+Math.ceil((tempDouble - +(~~tempDouble >>> 0)) / 4294967296) >>> 0 : 0)], HEAP32[buf + 40 >> 2] = tempI64[0], HEAP32[buf + 44 >> 2] = tempI64[1];
    HEAPU32[buf + 48 >> 2] = atime % 1e3 * 1e3;
    tempI64 = [Math.floor(mtime / 1e3) >>> 0, (tempDouble = Math.floor(mtime / 1e3), +Math.abs(tempDouble) >= 1 ? tempDouble > 0 ? +Math.floor(tempDouble / 4294967296) >>> 0 : ~~+Math.ceil((tempDouble - +(~~tempDouble >>> 0)) / 4294967296) >>> 0 : 0)], HEAP32[buf + 56 >> 2] = tempI64[0], HEAP32[buf + 60 >> 2] = tempI64[1];
    HEAPU32[buf + 64 >> 2] = mtime % 1e3 * 1e3;
    tempI64 = [Math.floor(ctime / 1e3) >>> 0, (tempDouble = Math.floor(ctime / 1e3), +Math.abs(tempDouble) >= 1 ? tempDouble > 0 ? +Math.floor(tempDouble / 4294967296) >>> 0 : ~~+Math.ceil((tempDouble - +(~~tempDouble >>> 0)) / 4294967296) >>> 0 : 0)], HEAP32[buf + 72 >> 2] = tempI64[0], HEAP32[buf + 76 >> 2] = tempI64[1];
    HEAPU32[buf + 80 >> 2] = ctime % 1e3 * 1e3;
    tempI64 = [stat.ino >>> 0, (tempDouble = stat.ino, +Math.abs(tempDouble) >= 1 ? tempDouble > 0 ? +Math.floor(tempDouble / 4294967296) >>> 0 : ~~+Math.ceil((tempDouble - +(~~tempDouble >>> 0)) / 4294967296) >>> 0 : 0)], HEAP32[buf + 88 >> 2] = tempI64[0], HEAP32[buf + 92 >> 2] = tempI64[1];
    return 0;
  },
  doMsync: function doMsync(addr, stream, len, flags, offset) {
    if (!FS.isFile(stream.node.mode)) {
      throw new FS.ErrnoError(43);
    }
    if (flags & 2) {
      return 0;
    }
    var buffer = HEAPU8.slice(addr, addr + len);
    FS.msync(stream, buffer, offset, len, flags);
  },
  varargs: undefined,
  get: function get() {
    var ret = HEAP32[+SYSCALLS.varargs >> 2];
    SYSCALLS.varargs += 4;
    return ret;
  },
  getp: function getp() {
    return SYSCALLS.get();
  },
  getStr: function getStr(ptr) {
    var ret = UTF8ToString(ptr);
    return ret;
  },
  getStreamFromFD: function getStreamFromFD(fd) {
    var stream = FS.getStreamChecked(fd);
    return stream;
  }
};
function ___syscall__newselect(nfds, readfds, writefds, exceptfds, timeout) {
  try {
    var total = 0;
    var srcReadLow = readfds ? HEAP32[readfds >> 2] : 0,
      srcReadHigh = readfds ? HEAP32[readfds + 4 >> 2] : 0;
    var srcWriteLow = writefds ? HEAP32[writefds >> 2] : 0,
      srcWriteHigh = writefds ? HEAP32[writefds + 4 >> 2] : 0;
    var srcExceptLow = exceptfds ? HEAP32[exceptfds >> 2] : 0,
      srcExceptHigh = exceptfds ? HEAP32[exceptfds + 4 >> 2] : 0;
    var dstReadLow = 0,
      dstReadHigh = 0;
    var dstWriteLow = 0,
      dstWriteHigh = 0;
    var dstExceptLow = 0,
      dstExceptHigh = 0;
    var allLow = (readfds ? HEAP32[readfds >> 2] : 0) | (writefds ? HEAP32[writefds >> 2] : 0) | (exceptfds ? HEAP32[exceptfds >> 2] : 0);
    var allHigh = (readfds ? HEAP32[readfds + 4 >> 2] : 0) | (writefds ? HEAP32[writefds + 4 >> 2] : 0) | (exceptfds ? HEAP32[exceptfds + 4 >> 2] : 0);
    var check = function check(fd, low, high, val) {
      return fd < 32 ? low & val : high & val;
    };
    for (var fd = 0; fd < nfds; fd++) {
      var mask = 1 << fd % 32;
      if (!check(fd, allLow, allHigh, mask)) {
        continue;
      }
      var stream = SYSCALLS.getStreamFromFD(fd);
      var flags = SYSCALLS.DEFAULT_POLLMASK;
      if (stream.stream_ops.poll) {
        var timeoutInMillis = -1;
        if (timeout) {
          var tv_sec = readfds ? HEAP32[timeout >> 2] : 0,
            tv_usec = readfds ? HEAP32[timeout + 4 >> 2] : 0;
          timeoutInMillis = (tv_sec + tv_usec / 1e6) * 1e3;
        }
        flags = stream.stream_ops.poll(stream, timeoutInMillis);
      }
      if (flags & 1 && check(fd, srcReadLow, srcReadHigh, mask)) {
        fd < 32 ? dstReadLow = dstReadLow | mask : dstReadHigh = dstReadHigh | mask;
        total++;
      }
      if (flags & 4 && check(fd, srcWriteLow, srcWriteHigh, mask)) {
        fd < 32 ? dstWriteLow = dstWriteLow | mask : dstWriteHigh = dstWriteHigh | mask;
        total++;
      }
      if (flags & 2 && check(fd, srcExceptLow, srcExceptHigh, mask)) {
        fd < 32 ? dstExceptLow = dstExceptLow | mask : dstExceptHigh = dstExceptHigh | mask;
        total++;
      }
    }
    if (readfds) {
      HEAP32[readfds >> 2] = dstReadLow;
      HEAP32[readfds + 4 >> 2] = dstReadHigh;
    }
    if (writefds) {
      HEAP32[writefds >> 2] = dstWriteLow;
      HEAP32[writefds + 4 >> 2] = dstWriteHigh;
    }
    if (exceptfds) {
      HEAP32[exceptfds >> 2] = dstExceptLow;
      HEAP32[exceptfds + 4 >> 2] = dstExceptHigh;
    }
    return total;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
var SOCKFS = {
  mount: function mount(_mount2) {
    Module["websocket"] = Module["websocket"] && "object" === _typeof(Module["websocket"]) ? Module["websocket"] : {};
    Module["websocket"]._callbacks = {};
    Module["websocket"]["on"] = function (event, callback) {
      if ("function" === typeof callback) {
        this._callbacks[event] = callback;
      }
      return this;
    };
    Module["websocket"].emit = function (event, param) {
      if ("function" === typeof this._callbacks[event]) {
        this._callbacks[event].call(this, param);
      }
    };
    return FS.createNode(null, "/", 16384 | 511, 0);
  },
  createSocket: function createSocket(family, type, protocol) {
    type &= ~526336;
    var streaming = type == 1;
    if (streaming && protocol && protocol != 6) {
      throw new FS.ErrnoError(66);
    }
    var sock = {
      family: family,
      type: type,
      protocol: protocol,
      server: null,
      error: null,
      peers: {},
      pending: [],
      recv_queue: [],
      sock_ops: SOCKFS.websocket_sock_ops
    };
    var name = SOCKFS.nextname();
    var node = FS.createNode(SOCKFS.root, name, 49152, 0);
    node.sock = sock;
    var stream = FS.createStream({
      path: name,
      node: node,
      flags: 2,
      seekable: false,
      stream_ops: SOCKFS.stream_ops
    });
    sock.stream = stream;
    return sock;
  },
  getSocket: function getSocket(fd) {
    var stream = FS.getStream(fd);
    if (!stream || !FS.isSocket(stream.node.mode)) {
      return null;
    }
    return stream.node.sock;
  },
  stream_ops: {
    poll: function poll(stream) {
      var sock = stream.node.sock;
      return sock.sock_ops.poll(sock);
    },
    ioctl: function ioctl(stream, request, varargs) {
      var sock = stream.node.sock;
      return sock.sock_ops.ioctl(sock, request, varargs);
    },
    read: function read(stream, buffer, offset, length, position) {
      var sock = stream.node.sock;
      var msg = sock.sock_ops.recvmsg(sock, length);
      if (!msg) {
        return 0;
      }
      buffer.set(msg.buffer, offset);
      return msg.buffer.length;
    },
    write: function write(stream, buffer, offset, length, position) {
      var sock = stream.node.sock;
      return sock.sock_ops.sendmsg(sock, buffer, offset, length);
    },
    close: function close(stream) {
      var sock = stream.node.sock;
      sock.sock_ops.close(sock);
    }
  },
  nextname: function nextname() {
    if (!SOCKFS.nextname.current) {
      SOCKFS.nextname.current = 0;
    }
    return "socket[" + SOCKFS.nextname.current++ + "]";
  },
  websocket_sock_ops: {
    createPeer: function createPeer(sock, addr, port) {
      var ws;
      if (_typeof(addr) == "object") {
        ws = addr;
        addr = null;
        port = null;
      }
      if (ws) {
        if (ws._socket) {
          addr = ws._socket.remoteAddress;
          port = ws._socket.remotePort;
        } else {
          var result = /ws[s]?:\/\/([^:]+):(\d+)/.exec(ws.url);
          if (!result) {
            throw new Error("WebSocket URL must be in the format ws(s)://address:port");
          }
          addr = result[1];
          port = parseInt(result[2], 10);
        }
      } else {
        try {
          var runtimeConfig = Module["websocket"] && "object" === _typeof(Module["websocket"]);
          var url = "ws:#".replace("#", "//");
          if (runtimeConfig) {
            if ("string" === typeof Module["websocket"]["url"]) {
              url = Module["websocket"]["url"];
            }
          }
          if (url === "ws://" || url === "wss://") {
            var parts = addr.split("/");
            url = url + parts[0] + ":" + port + "/" + parts.slice(1).join("/");
          }
          var subProtocols = "binary";
          if (runtimeConfig) {
            if ("string" === typeof Module["websocket"]["subprotocol"]) {
              subProtocols = Module["websocket"]["subprotocol"];
            }
          }
          var opts = undefined;
          if (subProtocols !== "null") {
            subProtocols = subProtocols.replace(/^ +| +$/g, "").split(/ *, */);
            opts = subProtocols;
          }
          if (runtimeConfig && null === Module["websocket"]["subprotocol"]) {
            subProtocols = "null";
            opts = undefined;
          }
          var WebSocketConstructor;
          if (ENVIRONMENT_IS_NODE) {
            WebSocketConstructor = require("ws");
          } else {
            WebSocketConstructor = WebSocket;
          }
          ws = new WebSocketConstructor(url, opts);
          ws.binaryType = "arraybuffer";
        } catch (e) {
          throw new FS.ErrnoError(23);
        }
      }
      var peer = {
        addr: addr,
        port: port,
        socket: ws,
        dgram_send_queue: []
      };
      SOCKFS.websocket_sock_ops.addPeer(sock, peer);
      SOCKFS.websocket_sock_ops.handlePeerEvents(sock, peer);
      if (sock.type === 2 && typeof sock.sport != "undefined") {
        peer.dgram_send_queue.push(new Uint8Array([255, 255, 255, 255, "p".charCodeAt(0), "o".charCodeAt(0), "r".charCodeAt(0), "t".charCodeAt(0), (sock.sport & 65280) >> 8, sock.sport & 255]));
      }
      return peer;
    },
    getPeer: function getPeer(sock, addr, port) {
      return sock.peers[addr + ":" + port];
    },
    addPeer: function addPeer(sock, peer) {
      sock.peers[peer.addr + ":" + peer.port] = peer;
    },
    removePeer: function removePeer(sock, peer) {
      delete sock.peers[peer.addr + ":" + peer.port];
    },
    handlePeerEvents: function handlePeerEvents(sock, peer) {
      var first = true;
      var handleOpen = function handleOpen() {
        Module["websocket"].emit("open", sock.stream.fd);
        try {
          var queued = peer.dgram_send_queue.shift();
          while (queued) {
            peer.socket.send(queued);
            queued = peer.dgram_send_queue.shift();
          }
        } catch (e) {
          peer.socket.close();
        }
      };
      function handleMessage(data) {
        if (typeof data == "string") {
          var encoder = new TextEncoder();
          data = encoder.encode(data);
        } else {
          assert(data.byteLength !== undefined);
          if (data.byteLength == 0) {
            return;
          }
          data = new Uint8Array(data);
        }
        var wasfirst = first;
        first = false;
        if (wasfirst && data.length === 10 && data[0] === 255 && data[1] === 255 && data[2] === 255 && data[3] === 255 && data[4] === "p".charCodeAt(0) && data[5] === "o".charCodeAt(0) && data[6] === "r".charCodeAt(0) && data[7] === "t".charCodeAt(0)) {
          var newport = data[8] << 8 | data[9];
          SOCKFS.websocket_sock_ops.removePeer(sock, peer);
          peer.port = newport;
          SOCKFS.websocket_sock_ops.addPeer(sock, peer);
          return;
        }
        sock.recv_queue.push({
          addr: peer.addr,
          port: peer.port,
          data: data
        });
        Module["websocket"].emit("message", sock.stream.fd);
      }
      if (ENVIRONMENT_IS_NODE) {
        peer.socket.on("open", handleOpen);
        peer.socket.on("message", function (data, isBinary) {
          if (!isBinary) {
            return;
          }
          handleMessage(new Uint8Array(data).buffer);
        });
        peer.socket.on("close", function () {
          Module["websocket"].emit("close", sock.stream.fd);
        });
        peer.socket.on("error", function (error) {
          sock.error = 14;
          Module["websocket"].emit("error", [sock.stream.fd, sock.error, "ECONNREFUSED: Connection refused"]);
        });
      } else {
        peer.socket.onopen = handleOpen;
        peer.socket.onclose = function () {
          Module["websocket"].emit("close", sock.stream.fd);
        };
        peer.socket.onmessage = function peer_socket_onmessage(event) {
          handleMessage(event.data);
        };
        peer.socket.onerror = function (error) {
          sock.error = 14;
          Module["websocket"].emit("error", [sock.stream.fd, sock.error, "ECONNREFUSED: Connection refused"]);
        };
      }
    },
    poll: function poll(sock) {
      if (sock.type === 1 && sock.server) {
        return sock.pending.length ? 64 | 1 : 0;
      }
      var mask = 0;
      var dest = sock.type === 1 ? SOCKFS.websocket_sock_ops.getPeer(sock, sock.daddr, sock.dport) : null;
      if (sock.recv_queue.length || !dest || dest && dest.socket.readyState === dest.socket.CLOSING || dest && dest.socket.readyState === dest.socket.CLOSED) {
        mask |= 64 | 1;
      }
      if (!dest || dest && dest.socket.readyState === dest.socket.OPEN) {
        mask |= 4;
      }
      if (dest && dest.socket.readyState === dest.socket.CLOSING || dest && dest.socket.readyState === dest.socket.CLOSED) {
        mask |= 16;
      }
      return mask;
    },
    ioctl: function ioctl(sock, request, arg) {
      switch (request) {
        case 21531:
          var bytes = 0;
          if (sock.recv_queue.length) {
            bytes = sock.recv_queue[0].data.length;
          }
          HEAP32[arg >> 2] = bytes;
          return 0;
        default:
          return 28;
      }
    },
    close: function close(sock) {
      if (sock.server) {
        try {
          sock.server.close();
        } catch (e) {}
        sock.server = null;
      }
      var peers = Object.keys(sock.peers);
      for (var i = 0; i < peers.length; i++) {
        var peer = sock.peers[peers[i]];
        try {
          peer.socket.close();
        } catch (e) {}
        SOCKFS.websocket_sock_ops.removePeer(sock, peer);
      }
      return 0;
    },
    bind: function bind(sock, addr, port) {
      if (typeof sock.saddr != "undefined" || typeof sock.sport != "undefined") {
        throw new FS.ErrnoError(28);
      }
      sock.saddr = addr;
      sock.sport = port;
      if (sock.type === 2) {
        if (sock.server) {
          sock.server.close();
          sock.server = null;
        }
        try {
          sock.sock_ops.listen(sock, 0);
        } catch (e) {
          if (!(e.name === "ErrnoError")) throw e;
          if (e.errno !== 138) throw e;
        }
      }
    },
    connect: function connect(sock, addr, port) {
      if (sock.server) {
        throw new FS.ErrnoError(138);
      }
      if (typeof sock.daddr != "undefined" && typeof sock.dport != "undefined") {
        var dest = SOCKFS.websocket_sock_ops.getPeer(sock, sock.daddr, sock.dport);
        if (dest) {
          if (dest.socket.readyState === dest.socket.CONNECTING) {
            throw new FS.ErrnoError(7);
          } else {
            throw new FS.ErrnoError(30);
          }
        }
      }
      var peer = SOCKFS.websocket_sock_ops.createPeer(sock, addr, port);
      sock.daddr = peer.addr;
      sock.dport = peer.port;
      throw new FS.ErrnoError(26);
    },
    listen: function listen(sock, backlog) {
      if (!ENVIRONMENT_IS_NODE) {
        throw new FS.ErrnoError(138);
      }
      if (sock.server) {
        throw new FS.ErrnoError(28);
      }
      var WebSocketServer = require("ws").Server;
      var host = sock.saddr;
      sock.server = new WebSocketServer({
        host: host,
        port: sock.sport
      });
      Module["websocket"].emit("listen", sock.stream.fd);
      sock.server.on("connection", function (ws) {
        if (sock.type === 1) {
          var newsock = SOCKFS.createSocket(sock.family, sock.type, sock.protocol);
          var peer = SOCKFS.websocket_sock_ops.createPeer(newsock, ws);
          newsock.daddr = peer.addr;
          newsock.dport = peer.port;
          sock.pending.push(newsock);
          Module["websocket"].emit("connection", newsock.stream.fd);
        } else {
          SOCKFS.websocket_sock_ops.createPeer(sock, ws);
          Module["websocket"].emit("connection", sock.stream.fd);
        }
      });
      sock.server.on("close", function () {
        Module["websocket"].emit("close", sock.stream.fd);
        sock.server = null;
      });
      sock.server.on("error", function (error) {
        sock.error = 23;
        Module["websocket"].emit("error", [sock.stream.fd, sock.error, "EHOSTUNREACH: Host is unreachable"]);
      });
    },
    accept: function accept(listensock) {
      if (!listensock.server || !listensock.pending.length) {
        throw new FS.ErrnoError(28);
      }
      var newsock = listensock.pending.shift();
      newsock.stream.flags = listensock.stream.flags;
      return newsock;
    },
    getname: function getname(sock, peer) {
      var addr, port;
      if (peer) {
        if (sock.daddr === undefined || sock.dport === undefined) {
          throw new FS.ErrnoError(53);
        }
        addr = sock.daddr;
        port = sock.dport;
      } else {
        addr = sock.saddr || 0;
        port = sock.sport || 0;
      }
      return {
        addr: addr,
        port: port
      };
    },
    sendmsg: function sendmsg(sock, buffer, offset, length, addr, port) {
      if (sock.type === 2) {
        if (addr === undefined || port === undefined) {
          addr = sock.daddr;
          port = sock.dport;
        }
        if (addr === undefined || port === undefined) {
          throw new FS.ErrnoError(17);
        }
      } else {
        addr = sock.daddr;
        port = sock.dport;
      }
      var dest = SOCKFS.websocket_sock_ops.getPeer(sock, addr, port);
      if (sock.type === 1) {
        if (!dest || dest.socket.readyState === dest.socket.CLOSING || dest.socket.readyState === dest.socket.CLOSED) {
          throw new FS.ErrnoError(53);
        } else if (dest.socket.readyState === dest.socket.CONNECTING) {
          throw new FS.ErrnoError(6);
        }
      }
      if (ArrayBuffer.isView(buffer)) {
        offset += buffer.byteOffset;
        buffer = buffer.buffer;
      }
      var data;
      data = buffer.slice(offset, offset + length);
      if (sock.type === 2) {
        if (!dest || dest.socket.readyState !== dest.socket.OPEN) {
          if (!dest || dest.socket.readyState === dest.socket.CLOSING || dest.socket.readyState === dest.socket.CLOSED) {
            dest = SOCKFS.websocket_sock_ops.createPeer(sock, addr, port);
          }
          dest.dgram_send_queue.push(data);
          return length;
        }
      }
      try {
        dest.socket.send(data);
        return length;
      } catch (e) {
        throw new FS.ErrnoError(28);
      }
    },
    recvmsg: function recvmsg(sock, length) {
      if (sock.type === 1 && sock.server) {
        throw new FS.ErrnoError(53);
      }
      var queued = sock.recv_queue.shift();
      if (!queued) {
        if (sock.type === 1) {
          var dest = SOCKFS.websocket_sock_ops.getPeer(sock, sock.daddr, sock.dport);
          if (!dest) {
            throw new FS.ErrnoError(53);
          }
          if (dest.socket.readyState === dest.socket.CLOSING || dest.socket.readyState === dest.socket.CLOSED) {
            return null;
          }
          throw new FS.ErrnoError(6);
        }
        throw new FS.ErrnoError(6);
      }
      var queuedLength = queued.data.byteLength || queued.data.length;
      var queuedOffset = queued.data.byteOffset || 0;
      var queuedBuffer = queued.data.buffer || queued.data;
      var bytesRead = Math.min(length, queuedLength);
      var res = {
        buffer: new Uint8Array(queuedBuffer, queuedOffset, bytesRead),
        addr: queued.addr,
        port: queued.port
      };
      if (sock.type === 1 && bytesRead < queuedLength) {
        var bytesRemaining = queuedLength - bytesRead;
        queued.data = new Uint8Array(queuedBuffer, queuedOffset + bytesRead, bytesRemaining);
        sock.recv_queue.unshift(queued);
      }
      return res;
    }
  }
};
var getSocketFromFD = function getSocketFromFD(fd) {
  var socket = SOCKFS.getSocket(fd);
  if (!socket) throw new FS.ErrnoError(8);
  return socket;
};
var inetPton4 = function inetPton4(str) {
  var b = str.split(".");
  for (var i = 0; i < 4; i++) {
    var tmp = Number(b[i]);
    if (isNaN(tmp)) return null;
    b[i] = tmp;
  }
  return (b[0] | b[1] << 8 | b[2] << 16 | b[3] << 24) >>> 0;
};
var jstoi_q = function jstoi_q(str) {
  return parseInt(str);
};
var inetPton6 = function inetPton6(str) {
  var words;
  var w, offset, z;
  var valid6regx = /^((?=.*::)(?!.*::.+::)(::)?([\dA-F]{1,4}:(:|\b)|){5}|([\dA-F]{1,4}:){6})((([\dA-F]{1,4}((?!\3)::|:\b|$))|(?!\2\3)){2}|(((2[0-4]|1\d|[1-9])?\d|25[0-5])\.?\b){4})$/i;
  var parts = [];
  if (!valid6regx.test(str)) {
    return null;
  }
  if (str === "::") {
    return [0, 0, 0, 0, 0, 0, 0, 0];
  }
  if (str.startsWith("::")) {
    str = str.replace("::", "Z:");
  } else {
    str = str.replace("::", ":Z:");
  }
  if (str.indexOf(".") > 0) {
    str = str.replace(new RegExp("[.]", "g"), ":");
    words = str.split(":");
    words[words.length - 4] = jstoi_q(words[words.length - 4]) + jstoi_q(words[words.length - 3]) * 256;
    words[words.length - 3] = jstoi_q(words[words.length - 2]) + jstoi_q(words[words.length - 1]) * 256;
    words = words.slice(0, words.length - 2);
  } else {
    words = str.split(":");
  }
  offset = 0;
  z = 0;
  for (w = 0; w < words.length; w++) {
    if (typeof words[w] == "string") {
      if (words[w] === "Z") {
        for (z = 0; z < 8 - words.length + 1; z++) {
          parts[w + z] = 0;
        }
        offset = z - 1;
      } else {
        parts[w + offset] = _htons2(parseInt(words[w], 16));
      }
    } else {
      parts[w + offset] = words[w];
    }
  }
  return [parts[1] << 16 | parts[0], parts[3] << 16 | parts[2], parts[5] << 16 | parts[4], parts[7] << 16 | parts[6]];
};
var writeSockaddr = function writeSockaddr(sa, family, addr, port, addrlen) {
  switch (family) {
    case 2:
      addr = inetPton4(addr);
      zeroMemory(sa, 16);
      if (addrlen) {
        HEAP32[addrlen >> 2] = 16;
      }
      HEAP16[sa >> 1] = family;
      HEAP32[sa + 4 >> 2] = addr;
      HEAP16[sa + 2 >> 1] = _htons2(port);
      break;
    case 10:
      addr = inetPton6(addr);
      zeroMemory(sa, 28);
      if (addrlen) {
        HEAP32[addrlen >> 2] = 28;
      }
      HEAP32[sa >> 2] = family;
      HEAP32[sa + 8 >> 2] = addr[0];
      HEAP32[sa + 12 >> 2] = addr[1];
      HEAP32[sa + 16 >> 2] = addr[2];
      HEAP32[sa + 20 >> 2] = addr[3];
      HEAP16[sa + 2 >> 1] = _htons2(port);
      break;
    default:
      return 5;
  }
  return 0;
};
var DNS = {
  address_map: {
    id: 1,
    addrs: {},
    names: {}
  },
  lookup_name: function lookup_name(name) {
    var res = inetPton4(name);
    if (res !== null) {
      return name;
    }
    res = inetPton6(name);
    if (res !== null) {
      return name;
    }
    var addr;
    if (DNS.address_map.addrs[name]) {
      addr = DNS.address_map.addrs[name];
    } else {
      var id = DNS.address_map.id++;
      assert(id < 65535, "exceeded max address mappings of 65535");
      addr = "172.29." + (id & 255) + "." + (id & 65280);
      DNS.address_map.names[addr] = name;
      DNS.address_map.addrs[name] = addr;
    }
    return addr;
  },
  lookup_addr: function lookup_addr(addr) {
    if (DNS.address_map.names[addr]) {
      return DNS.address_map.names[addr];
    }
    return null;
  }
};
function ___syscall_accept4(fd, addr, addrlen, flags, d1, d2) {
  try {
    var sock = getSocketFromFD(fd);
    var newsock = sock.sock_ops.accept(sock);
    if (addr) {
      var errno = writeSockaddr(addr, newsock.family, DNS.lookup_name(newsock.daddr), newsock.dport, addrlen);
    }
    return newsock.stream.fd;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
var inetNtop4 = function inetNtop4(addr) {
  return (addr & 255) + "." + (addr >> 8 & 255) + "." + (addr >> 16 & 255) + "." + (addr >> 24 & 255);
};
var inetNtop6 = function inetNtop6(ints) {
  var str = "";
  var word = 0;
  var longest = 0;
  var lastzero = 0;
  var zstart = 0;
  var len = 0;
  var i = 0;
  var parts = [ints[0] & 65535, ints[0] >> 16, ints[1] & 65535, ints[1] >> 16, ints[2] & 65535, ints[2] >> 16, ints[3] & 65535, ints[3] >> 16];
  var hasipv4 = true;
  var v4part = "";
  for (i = 0; i < 5; i++) {
    if (parts[i] !== 0) {
      hasipv4 = false;
      break;
    }
  }
  if (hasipv4) {
    v4part = inetNtop4(parts[6] | parts[7] << 16);
    if (parts[5] === -1) {
      str = "::ffff:";
      str += v4part;
      return str;
    }
    if (parts[5] === 0) {
      str = "::";
      if (v4part === "0.0.0.0") v4part = "";
      if (v4part === "0.0.0.1") v4part = "1";
      str += v4part;
      return str;
    }
  }
  for (word = 0; word < 8; word++) {
    if (parts[word] === 0) {
      if (word - lastzero > 1) {
        len = 0;
      }
      lastzero = word;
      len++;
    }
    if (len > longest) {
      longest = len;
      zstart = word - longest + 1;
    }
  }
  for (word = 0; word < 8; word++) {
    if (longest > 1) {
      if (parts[word] === 0 && word >= zstart && word < zstart + longest) {
        if (word === zstart) {
          str += ":";
          if (zstart === 0) str += ":";
        }
        continue;
      }
    }
    str += Number(_ntohs2(parts[word] & 65535)).toString(16);
    str += word < 7 ? ":" : "";
  }
  return str;
};
var readSockaddr = function readSockaddr(sa, salen) {
  var family = HEAP16[sa >> 1];
  var port = _ntohs2(HEAPU16[sa + 2 >> 1]);
  var addr;
  switch (family) {
    case 2:
      if (salen !== 16) {
        return {
          errno: 28
        };
      }
      addr = HEAP32[sa + 4 >> 2];
      addr = inetNtop4(addr);
      break;
    case 10:
      if (salen !== 28) {
        return {
          errno: 28
        };
      }
      addr = [HEAP32[sa + 8 >> 2], HEAP32[sa + 12 >> 2], HEAP32[sa + 16 >> 2], HEAP32[sa + 20 >> 2]];
      addr = inetNtop6(addr);
      break;
    default:
      return {
        errno: 5
      };
  }
  return {
    family: family,
    addr: addr,
    port: port
  };
};
var getSocketAddress = function getSocketAddress(addrp, addrlen, allowNull) {
  if (allowNull && addrp === 0) return null;
  var info = readSockaddr(addrp, addrlen);
  if (info.errno) throw new FS.ErrnoError(info.errno);
  info.addr = DNS.lookup_addr(info.addr) || info.addr;
  return info;
};
function ___syscall_bind(fd, addr, addrlen, d1, d2, d3) {
  try {
    var sock = getSocketFromFD(fd);
    var info = getSocketAddress(addr, addrlen);
    sock.sock_ops.bind(sock, info.addr, info.port);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_connect(fd, addr, addrlen, d1, d2, d3) {
  try {
    var sock = getSocketFromFD(fd);
    var info = getSocketAddress(addr, addrlen);
    sock.sock_ops.connect(sock, info.addr, info.port);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_dup3(fd, newfd, flags) {
  try {
    var old = SYSCALLS.getStreamFromFD(fd);
    if (old.fd === newfd) return -28;
    var existing = FS.getStream(newfd);
    if (existing) FS.close(existing);
    return FS.dupStream(old, newfd).fd;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_fcntl64(fd, cmd, varargs) {
  SYSCALLS.varargs = varargs;
  try {
    var stream = SYSCALLS.getStreamFromFD(fd);
    switch (cmd) {
      case 0:
        {
          var arg = SYSCALLS.get();
          if (arg < 0) {
            return -28;
          }
          while (FS.streams[arg]) {
            arg++;
          }
          var newStream;
          newStream = FS.dupStream(stream, arg);
          return newStream.fd;
        }
      case 1:
      case 2:
        return 0;
      case 3:
        return stream.flags;
      case 4:
        {
          var arg = SYSCALLS.get();
          stream.flags |= arg;
          return 0;
        }
      case 12:
        {
          var arg = SYSCALLS.getp();
          var offset = 0;
          HEAP16[arg + offset >> 1] = 2;
          return 0;
        }
      case 13:
      case 14:
        return 0;
    }
    return -28;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_getpeername(fd, addr, addrlen, d1, d2, d3) {
  try {
    var sock = getSocketFromFD(fd);
    if (!sock.daddr) {
      return -53;
    }
    var errno = writeSockaddr(addr, sock.family, DNS.lookup_name(sock.daddr), sock.dport, addrlen);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_getsockname(fd, addr, addrlen, d1, d2, d3) {
  try {
    var sock = getSocketFromFD(fd);
    var errno = writeSockaddr(addr, sock.family, DNS.lookup_name(sock.saddr || "0.0.0.0"), sock.sport, addrlen);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_getsockopt(fd, level, optname, optval, optlen, d1) {
  try {
    var sock = getSocketFromFD(fd);
    if (level === 1) {
      if (optname === 4) {
        HEAP32[optval >> 2] = sock.error;
        HEAP32[optlen >> 2] = 4;
        sock.error = null;
        return 0;
      }
    }
    return -50;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_ioctl(fd, op, varargs) {
  SYSCALLS.varargs = varargs;
  try {
    var stream = SYSCALLS.getStreamFromFD(fd);
    switch (op) {
      case 21509:
        {
          if (!stream.tty) return -59;
          return 0;
        }
      case 21505:
        {
          if (!stream.tty) return -59;
          if (stream.tty.ops.ioctl_tcgets) {
            var termios = stream.tty.ops.ioctl_tcgets(stream);
            var argp = SYSCALLS.getp();
            HEAP32[argp >> 2] = termios.c_iflag || 0;
            HEAP32[argp + 4 >> 2] = termios.c_oflag || 0;
            HEAP32[argp + 8 >> 2] = termios.c_cflag || 0;
            HEAP32[argp + 12 >> 2] = termios.c_lflag || 0;
            for (var i = 0; i < 32; i++) {
              HEAP8[argp + i + 17] = termios.c_cc[i] || 0;
            }
            return 0;
          }
          return 0;
        }
      case 21510:
      case 21511:
      case 21512:
        {
          if (!stream.tty) return -59;
          return 0;
        }
      case 21506:
      case 21507:
      case 21508:
        {
          if (!stream.tty) return -59;
          if (stream.tty.ops.ioctl_tcsets) {
            var argp = SYSCALLS.getp();
            var c_iflag = HEAP32[argp >> 2];
            var c_oflag = HEAP32[argp + 4 >> 2];
            var c_cflag = HEAP32[argp + 8 >> 2];
            var c_lflag = HEAP32[argp + 12 >> 2];
            var c_cc = [];
            for (var i = 0; i < 32; i++) {
              c_cc.push(HEAP8[argp + i + 17]);
            }
            return stream.tty.ops.ioctl_tcsets(stream.tty, op, {
              c_iflag: c_iflag,
              c_oflag: c_oflag,
              c_cflag: c_cflag,
              c_lflag: c_lflag,
              c_cc: c_cc
            });
          }
          return 0;
        }
      case 21519:
        {
          if (!stream.tty) return -59;
          var argp = SYSCALLS.getp();
          HEAP32[argp >> 2] = 0;
          return 0;
        }
      case 21520:
        {
          if (!stream.tty) return -59;
          return -28;
        }
      case 21531:
        {
          var argp = SYSCALLS.getp();
          return FS.ioctl(stream, op, argp);
        }
      case 21523:
        {
          if (!stream.tty) return -59;
          if (stream.tty.ops.ioctl_tiocgwinsz) {
            var winsize = stream.tty.ops.ioctl_tiocgwinsz(stream.tty);
            var argp = SYSCALLS.getp();
            HEAP16[argp >> 1] = winsize[0];
            HEAP16[argp + 2 >> 1] = winsize[1];
          }
          return 0;
        }
      case 21524:
        {
          if (!stream.tty) return -59;
          return 0;
        }
      case 21515:
        {
          if (!stream.tty) return -59;
          return 0;
        }
      default:
        return -28;
    }
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_listen(fd, backlog) {
  try {
    var sock = getSocketFromFD(fd);
    sock.sock_ops.listen(sock, backlog);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_mkdirat(dirfd, path, mode) {
  try {
    path = SYSCALLS.getStr(path);
    path = SYSCALLS.calculateAt(dirfd, path);
    path = PATH.normalize(path);
    if (path[path.length - 1] === "/") path = path.substr(0, path.length - 1);
    FS.mkdir(path, mode, 0);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_openat(dirfd, path, flags, varargs) {
  SYSCALLS.varargs = varargs;
  try {
    path = SYSCALLS.getStr(path);
    path = SYSCALLS.calculateAt(dirfd, path);
    var mode = varargs ? SYSCALLS.get() : 0;
    return FS.open(path, flags, mode).fd;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_poll(fds, nfds, timeout) {
  try {
    var nonzero = 0;
    for (var i = 0; i < nfds; i++) {
      var pollfd = fds + 8 * i;
      var fd = HEAP32[pollfd >> 2];
      var events = HEAP16[pollfd + 4 >> 1];
      var mask = 32;
      var stream = FS.getStream(fd);
      if (stream) {
        mask = SYSCALLS.DEFAULT_POLLMASK;
        if (stream.stream_ops.poll) {
          mask = stream.stream_ops.poll(stream, -1);
        }
      }
      mask &= events | 8 | 16;
      if (mask) nonzero++;
      HEAP16[pollfd + 6 >> 1] = mask;
    }
    return nonzero;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
var stringToUTF8 = function stringToUTF8(str, outPtr, maxBytesToWrite) {
  return stringToUTF8Array(str, HEAPU8, outPtr, maxBytesToWrite);
};
function ___syscall_readlinkat(dirfd, path, buf, bufsize) {
  try {
    path = SYSCALLS.getStr(path);
    path = SYSCALLS.calculateAt(dirfd, path);
    if (bufsize <= 0) return -28;
    var ret = FS.readlink(path);
    var len = Math.min(bufsize, lengthBytesUTF8(ret));
    var endChar = HEAP8[buf + len];
    stringToUTF8(ret, buf, bufsize + 1);
    HEAP8[buf + len] = endChar;
    return len;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_recvfrom(fd, buf, len, flags, addr, addrlen) {
  try {
    var sock = getSocketFromFD(fd);
    var msg = sock.sock_ops.recvmsg(sock, len);
    if (!msg) return 0;
    if (addr) {
      var errno = writeSockaddr(addr, sock.family, DNS.lookup_name(msg.addr), msg.port, addrlen);
    }
    HEAPU8.set(msg.buffer, buf);
    return msg.buffer.byteLength;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_renameat(olddirfd, oldpath, newdirfd, newpath) {
  try {
    oldpath = SYSCALLS.getStr(oldpath);
    newpath = SYSCALLS.getStr(newpath);
    oldpath = SYSCALLS.calculateAt(olddirfd, oldpath);
    newpath = SYSCALLS.calculateAt(newdirfd, newpath);
    FS.rename(oldpath, newpath);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_rmdir(path) {
  try {
    path = SYSCALLS.getStr(path);
    FS.rmdir(path);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_sendto(fd, message, length, flags, addr, addr_len) {
  try {
    var sock = getSocketFromFD(fd);
    var dest = getSocketAddress(addr, addr_len, true);
    if (!dest) {
      return FS.write(sock.stream, HEAP8, message, length);
    }
    return sock.sock_ops.sendmsg(sock, HEAP8, message, length, dest.addr, dest.port);
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_socket(domain, type, protocol) {
  try {
    var sock = SOCKFS.createSocket(domain, type, protocol);
    return sock.stream.fd;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_stat64(path, buf) {
  try {
    path = SYSCALLS.getStr(path);
    return SYSCALLS.doStat(FS.stat, path, buf);
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
function ___syscall_unlinkat(dirfd, path, flags) {
  try {
    path = SYSCALLS.getStr(path);
    path = SYSCALLS.calculateAt(dirfd, path);
    if (flags === 0) {
      FS.unlink(path);
    } else if (flags === 512) {
      FS.rmdir(path);
    } else {
      abort("Invalid flags passed to unlinkat");
    }
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return -e.errno;
  }
}
var nowIsMonotonic = 1;
var __emscripten_get_now_is_monotonic = function __emscripten_get_now_is_monotonic() {
  return nowIsMonotonic;
};
var __emscripten_lookup_name = function __emscripten_lookup_name(name) {
  var nameString = UTF8ToString(name);
  return inetPton4(DNS.lookup_name(nameString));
};
var __emscripten_system = function __emscripten_system(command) {
  if (ENVIRONMENT_IS_NODE) {
    if (!command) return 1;
    var cmdstr = UTF8ToString(command);
    if (!cmdstr.length) return 0;
    var cp = require("child_process");
    var ret = cp.spawnSync(cmdstr, [], {
      shell: true,
      stdio: "inherit"
    });
    var _W_EXITCODE = function _W_EXITCODE(ret, sig) {
      return ret << 8 | sig;
    };
    if (ret.status === null) {
      var signalToNumber = function signalToNumber(sig) {
        switch (sig) {
          case "SIGHUP":
            return 1;
          case "SIGINT":
            return 2;
          case "SIGQUIT":
            return 3;
          case "SIGFPE":
            return 8;
          case "SIGKILL":
            return 9;
          case "SIGALRM":
            return 14;
          case "SIGTERM":
            return 15;
        }
        return 2;
      };
      return _W_EXITCODE(0, signalToNumber(ret.signal));
    }
    return _W_EXITCODE(ret.status, 0);
  }
  if (!command) return 0;
  return -52;
};
var __emscripten_throw_longjmp = function __emscripten_throw_longjmp() {
  throw Infinity;
};
var convertI32PairToI53Checked = function convertI32PairToI53Checked(lo, hi) {
  return hi + 2097152 >>> 0 < 4194305 - !!lo ? (lo >>> 0) + hi * 4294967296 : NaN;
};
function __gmtime_js(time_low, time_high, tmPtr) {
  var time = convertI32PairToI53Checked(time_low, time_high);
  var date = new Date(time * 1e3);
  HEAP32[tmPtr >> 2] = date.getUTCSeconds();
  HEAP32[tmPtr + 4 >> 2] = date.getUTCMinutes();
  HEAP32[tmPtr + 8 >> 2] = date.getUTCHours();
  HEAP32[tmPtr + 12 >> 2] = date.getUTCDate();
  HEAP32[tmPtr + 16 >> 2] = date.getUTCMonth();
  HEAP32[tmPtr + 20 >> 2] = date.getUTCFullYear() - 1900;
  HEAP32[tmPtr + 24 >> 2] = date.getUTCDay();
  var start = Date.UTC(date.getUTCFullYear(), 0, 1, 0, 0, 0, 0);
  var yday = (date.getTime() - start) / (1e3 * 60 * 60 * 24) | 0;
  HEAP32[tmPtr + 28 >> 2] = yday;
}
var isLeapYear = function isLeapYear(year) {
  return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0);
};
var MONTH_DAYS_LEAP_CUMULATIVE = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335];
var MONTH_DAYS_REGULAR_CUMULATIVE = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
var ydayFromDate = function ydayFromDate(date) {
  var leap = isLeapYear(date.getFullYear());
  var monthDaysCumulative = leap ? MONTH_DAYS_LEAP_CUMULATIVE : MONTH_DAYS_REGULAR_CUMULATIVE;
  var yday = monthDaysCumulative[date.getMonth()] + date.getDate() - 1;
  return yday;
};
function __localtime_js(time_low, time_high, tmPtr) {
  var time = convertI32PairToI53Checked(time_low, time_high);
  var date = new Date(time * 1e3);
  HEAP32[tmPtr >> 2] = date.getSeconds();
  HEAP32[tmPtr + 4 >> 2] = date.getMinutes();
  HEAP32[tmPtr + 8 >> 2] = date.getHours();
  HEAP32[tmPtr + 12 >> 2] = date.getDate();
  HEAP32[tmPtr + 16 >> 2] = date.getMonth();
  HEAP32[tmPtr + 20 >> 2] = date.getFullYear() - 1900;
  HEAP32[tmPtr + 24 >> 2] = date.getDay();
  var yday = ydayFromDate(date) | 0;
  HEAP32[tmPtr + 28 >> 2] = yday;
  HEAP32[tmPtr + 36 >> 2] = -(date.getTimezoneOffset() * 60);
  var start = new Date(date.getFullYear(), 0, 1);
  var summerOffset = new Date(date.getFullYear(), 6, 1).getTimezoneOffset();
  var winterOffset = start.getTimezoneOffset();
  var dst = (summerOffset != winterOffset && date.getTimezoneOffset() == Math.min(winterOffset, summerOffset)) | 0;
  HEAP32[tmPtr + 32 >> 2] = dst;
}
var __mktime_js = function __mktime_js(tmPtr) {
  var ret = function () {
    var date = new Date(HEAP32[tmPtr + 20 >> 2] + 1900, HEAP32[tmPtr + 16 >> 2], HEAP32[tmPtr + 12 >> 2], HEAP32[tmPtr + 8 >> 2], HEAP32[tmPtr + 4 >> 2], HEAP32[tmPtr >> 2], 0);
    var dst = HEAP32[tmPtr + 32 >> 2];
    var guessedOffset = date.getTimezoneOffset();
    var start = new Date(date.getFullYear(), 0, 1);
    var summerOffset = new Date(date.getFullYear(), 6, 1).getTimezoneOffset();
    var winterOffset = start.getTimezoneOffset();
    var dstOffset = Math.min(winterOffset, summerOffset);
    if (dst < 0) {
      HEAP32[tmPtr + 32 >> 2] = Number(summerOffset != winterOffset && dstOffset == guessedOffset);
    } else if (dst > 0 != (dstOffset == guessedOffset)) {
      var nonDstOffset = Math.max(winterOffset, summerOffset);
      var trueOffset = dst > 0 ? dstOffset : nonDstOffset;
      date.setTime(date.getTime() + (trueOffset - guessedOffset) * 6e4);
    }
    HEAP32[tmPtr + 24 >> 2] = date.getDay();
    var yday = ydayFromDate(date) | 0;
    HEAP32[tmPtr + 28 >> 2] = yday;
    HEAP32[tmPtr >> 2] = date.getSeconds();
    HEAP32[tmPtr + 4 >> 2] = date.getMinutes();
    HEAP32[tmPtr + 8 >> 2] = date.getHours();
    HEAP32[tmPtr + 12 >> 2] = date.getDate();
    HEAP32[tmPtr + 16 >> 2] = date.getMonth();
    HEAP32[tmPtr + 20 >> 2] = date.getYear();
    var timeMs = date.getTime();
    if (isNaN(timeMs)) {
      return -1;
    }
    return timeMs / 1e3;
  }();
  return _setTempRet((tempDouble = ret, +Math.abs(tempDouble) >= 1 ? tempDouble > 0 ? +Math.floor(tempDouble / 4294967296) >>> 0 : ~~+Math.ceil((tempDouble - +(~~tempDouble >>> 0)) / 4294967296) >>> 0 : 0)), ret >>> 0;
};
var __tzset_js = function __tzset_js(timezone, daylight, std_name, dst_name) {
  var currentYear = new Date().getFullYear();
  var winter = new Date(currentYear, 0, 1);
  var summer = new Date(currentYear, 6, 1);
  var winterOffset = winter.getTimezoneOffset();
  var summerOffset = summer.getTimezoneOffset();
  var stdTimezoneOffset = Math.max(winterOffset, summerOffset);
  HEAPU32[timezone >> 2] = stdTimezoneOffset * 60;
  HEAP32[daylight >> 2] = Number(winterOffset != summerOffset);
  function extractZone(date) {
    var match = date.toTimeString().match(/\(([A-Za-z ]+)\)$/);
    return match ? match[1] : "GMT";
  }
  var winterName = extractZone(winter);
  var summerName = extractZone(summer);
  if (summerOffset < winterOffset) {
    stringToUTF8(winterName, std_name, 7);
    stringToUTF8(summerName, dst_name, 7);
  } else {
    stringToUTF8(winterName, dst_name, 7);
    stringToUTF8(summerName, std_name, 7);
  }
};
var _abort = function _abort() {
  abort("");
};
var DefoldSoundDevice = {
  TryResumeAudio: function TryResumeAudio() {
    var audioCtx = window._dmJSDeviceShared.audioCtx;
    if (audioCtx !== undefined && audioCtx.state != "running") {
      audioCtx.resume();
    }
  }
};
function _dmDeviceJSFreeBufferSlots(id) {
  return window._dmJSDeviceShared.devices[id]._freeBufferSlots();
}
function _dmDeviceJSOpen(bufferCount) {
  var shared = window._dmJSDeviceShared;
  if (shared === undefined) {
    shared = {
      count: 0,
      devices: {}
    };
    window._dmJSDeviceShared = shared;
  }
  var id = shared.count++;
  var device;
  if (window.AudioContext || window.webkitAudioContext) {
    if (shared.audioCtx === undefined) {
      var audioCtxCtor = window.AudioContext || window.webkitAudioContext;
      try {
        shared.audioCtx = new audioCtxCtor({
          sampleRate: 44100
        });
      } catch (e) {
        shared.audioCtx = new audioCtxCtor();
      }
    }
    device = {
      sampleRate: shared.audioCtx.sampleRate,
      bufferedTo: 0,
      bufferDuration: 0,
      creatingTime: Date.now() / 1e3,
      lastTimeInSuspendedState: Date.now() / 1e3,
      suspendedBufferedTo: 0,
      _isContextRunning: function _isContextRunning() {
        var audioCtx = window._dmJSDeviceShared.audioCtx;
        return audioCtx !== undefined && audioCtx.state == "running";
      },
      _getCurrentSuspendedTime: function _getCurrentSuspendedTime() {
        if (!this._isContextRunning()) {
          this.lastTimeInSuspendedState = Date.now() / 1e3;
          return this.lastTimeInSuspendedState - this.creatingTime;
        }
        return 0;
      },
      _queue: function _queue(samples, sample_count) {
        var len = sample_count / this.sampleRate;
        this.bufferDuration = len;
        if (!this._isContextRunning()) {
          this.suspendedBufferedTo += len;
          return;
        }
        var buf = shared.audioCtx.createBuffer(2, sample_count, this.sampleRate);
        var c0 = buf.getChannelData(0);
        var c1 = buf.getChannelData(1);
        for (var i = 0; i < sample_count; i++) {
          c0[i] = getValue(samples + 4 * i, "i16") / 32768;
          c1[i] = getValue(samples + 4 * i + 2, "i16") / 32768;
        }
        var source = shared.audioCtx.createBufferSource();
        source.buffer = buf;
        source.connect(shared.audioCtx.destination);
        var t = shared.audioCtx.currentTime;
        if (this.bufferedTo <= t) {
          source.start(t);
          this.bufferedTo = t + len;
        } else {
          source.start(this.bufferedTo);
          this.bufferedTo = this.bufferedTo + len;
        }
      },
      _freeBufferSlots: function _freeBufferSlots() {
        var ahead = 0;
        if (this._isContextRunning()) {
          if (this.bufferDuration == 0) return 1;
          ahead = this.bufferedTo - shared.audioCtx.currentTime;
        } else {
          ahead = this.suspendedBufferedTo - this._getCurrentSuspendedTime();
        }
        var inqueue = Math.ceil(ahead / this.bufferDuration);
        if (inqueue < 0) {
          inqueue = 0;
        }
        var left = bufferCount - inqueue;
        if (left < 0) {
          return 0;
        }
        return left;
      }
    };
  }
  if (device != null) {
    shared.audioCtx.onstatechanged = function () {
      if (device._isContextRunning()) {
        device.timeInSuspendedState = Date.now() / 1e3;
      } else {
        device.creatingTime = Date.now() / 1e3;
        device.lastTimeInSuspendedState = Date.now() / 1e3;
        device.suspendedBufferedTo = 0;
      }
    };
    shared.devices[id] = device;
    return id;
  }
  return -1;
}
function _dmDeviceJSQueue(id, samples, sample_count) {
  window._dmJSDeviceShared.devices[id]._queue(samples, sample_count);
}
function _dmGetDeviceSampleRate(id) {
  return window._dmJSDeviceShared.devices[id].sampleRate;
}
var wasmTableMirror = [];
var wasmTable;
var getWasmTableEntry = function getWasmTableEntry(funcPtr) {
  var func = wasmTableMirror[funcPtr];
  if (!func) {
    if (funcPtr >= wasmTableMirror.length) wasmTableMirror.length = funcPtr + 1;
    wasmTableMirror[funcPtr] = func = wasmTable.get(funcPtr);
  }
  return func;
};
function _dmScriptHttpRequestAsync(method, url, headers, arg, onload, onerror, onprogress, send_data, send_data_length, timeout) {
  var xhr = new XMLHttpRequest();
  function listener() {
    var resp_headers = xhr.getAllResponseHeaders();
    resp_headers = resp_headers.replace(new RegExp("\r", "g"), "");
    resp_headers += "\n";
    if (xhr.status != 0) {
      var ab = new Uint8Array(xhr.response);
      var b = _malloc(ab.length * ab.BYTES_PER_ELEMENT);
      HEAPU8.set(ab, b);
      var resp_headers_buffer = stringToNewUTF8(resp_headers);
      getWasmTableEntry(onload)(arg, xhr.status, b, ab.length, resp_headers_buffer);
      _free(resp_headers_buffer);
      _free(b);
    } else {
      getWasmTableEntry(onerror)(arg, xhr.status);
    }
  }
  xhr.onload = listener;
  xhr.onerror = listener;
  xhr.ontimeout = listener;
  xhr.onprogress = function (progress_event) {
    if (onprogress != 0) {
      getWasmTableEntry(onprogress)(arg, progress_event.loaded, progress_event.total);
    }
  };
  xhr.open(UTF8ToString(method), UTF8ToString(url), true);
  xhr.responseType = "arraybuffer";
  if (timeout > 0) {
    xhr.timeout = timeout / 1e3;
  }
  var headersArray = UTF8ToString(headers).split("\n");
  for (var i = 0; i < headersArray.length; i++) {
    if (headersArray[i].trim() != "") {
      var a = headersArray[i].split(":");
      xhr.setRequestHeader(a[0], a[1]);
    }
  }
  if (send_data_length > 0) {
    xhr.send(HEAPU8.subarray(send_data, send_data + send_data_length));
  } else {
    xhr.send();
  }
}
var DMSYS = {
  _folder: "/data",
  _cstr: null,
  GetUserPersistentDataRoot: function GetUserPersistentDataRoot() {
    if (typeof window !== "undefined") return DMSYS._folder;else return "";
  },
  PumpMessageQueue: function PumpMessageQueue() {
    if (typeof window === "undefined") {
      var uvrun = require("uvrun");
      uvrun.runOnce();
    }
  }
};
function _dmSysGetApplicationPath() {
  var path = location.href.substring(0, location.href.lastIndexOf("/"));
  var buffer = stringToNewUTF8(path);
  return buffer;
}
function _dmSysGetUserAgent() {
  var useragent = navigator.userAgent;
  var buffer = stringToNewUTF8(useragent);
  return buffer;
}
function _dmSysGetUserPersistentDataRoot() {
  if (null == DMSYS._cstr) {
    var str = DMSYS.GetUserPersistentDataRoot();
    DMSYS._cstr = stringToNewUTF8(str);
  }
  return DMSYS._cstr;
}
function _dmSysGetUserPreferredLanguage(defaultlang) {
  var jsdefault = UTF8ToString(defaultlang);
  var preferred = navigator == undefined ? jsdefault : navigator.languages ? navigator.languages[0] || jsdefault : navigator.language || navigator.userLanguage || navigator.browserLanguage || navigator.systemLanguage || jsdefault;
  var buffer = stringToNewUTF8(preferred);
  return buffer;
}
var JSEvents = {
  removeAllEventListeners: function removeAllEventListeners() {
    while (JSEvents.eventHandlers.length) {
      JSEvents._removeHandler(JSEvents.eventHandlers.length - 1);
    }
    JSEvents.deferredCalls = [];
  },
  inEventHandler: 0,
  deferredCalls: [],
  deferCall: function deferCall(targetFunction, precedence, argsList) {
    function arraysHaveEqualContent(arrA, arrB) {
      if (arrA.length != arrB.length) return false;
      for (var i in arrA) {
        if (arrA[i] != arrB[i]) return false;
      }
      return true;
    }
    for (var i in JSEvents.deferredCalls) {
      var call = JSEvents.deferredCalls[i];
      if (call.targetFunction == targetFunction && arraysHaveEqualContent(call.argsList, argsList)) {
        return;
      }
    }
    JSEvents.deferredCalls.push({
      targetFunction: targetFunction,
      precedence: precedence,
      argsList: argsList
    });
    JSEvents.deferredCalls.sort(function (x, y) {
      return x.precedence < y.precedence;
    });
  },
  removeDeferredCalls: function removeDeferredCalls(targetFunction) {
    for (var i = 0; i < JSEvents.deferredCalls.length; ++i) {
      if (JSEvents.deferredCalls[i].targetFunction == targetFunction) {
        JSEvents.deferredCalls.splice(i, 1);
        --i;
      }
    }
  },
  canPerformEventHandlerRequests: function canPerformEventHandlerRequests() {
    if (navigator.userActivation) {
      return navigator.userActivation.isActive;
    }
    return JSEvents.inEventHandler && JSEvents.currentEventHandler.allowsDeferredCalls;
  },
  runDeferredCalls: function runDeferredCalls() {
    if (!JSEvents.canPerformEventHandlerRequests()) {
      return;
    }
    for (var i = 0; i < JSEvents.deferredCalls.length; ++i) {
      var _call;
      var call = JSEvents.deferredCalls[i];
      JSEvents.deferredCalls.splice(i, 1);
      --i;
      (_call = call).targetFunction.apply(_call, _toConsumableArray(call.argsList));
    }
  },
  eventHandlers: [],
  removeAllHandlersOnTarget: function removeAllHandlersOnTarget(target, eventTypeString) {
    for (var i = 0; i < JSEvents.eventHandlers.length; ++i) {
      if (JSEvents.eventHandlers[i].target == target && (!eventTypeString || eventTypeString == JSEvents.eventHandlers[i].eventTypeString)) {
        JSEvents._removeHandler(i--);
      }
    }
  },
  _removeHandler: function _removeHandler(i) {
    var h = JSEvents.eventHandlers[i];
    h.target.removeEventListener(h.eventTypeString, h.eventListenerFunc, h.useCapture);
    JSEvents.eventHandlers.splice(i, 1);
  },
  registerOrRemoveHandler: function registerOrRemoveHandler(eventHandler) {
    if (!eventHandler.target) {
      return -4;
    }
    if (eventHandler.callbackfunc) {
      eventHandler.eventListenerFunc = function (event) {
        ++JSEvents.inEventHandler;
        JSEvents.currentEventHandler = eventHandler;
        JSEvents.runDeferredCalls();
        eventHandler.handlerFunc(event);
        JSEvents.runDeferredCalls();
        --JSEvents.inEventHandler;
      };
      eventHandler.target.addEventListener(eventHandler.eventTypeString, eventHandler.eventListenerFunc, eventHandler.useCapture);
      JSEvents.eventHandlers.push(eventHandler);
    } else {
      for (var i = 0; i < JSEvents.eventHandlers.length; ++i) {
        if (JSEvents.eventHandlers[i].target == eventHandler.target && JSEvents.eventHandlers[i].eventTypeString == eventHandler.eventTypeString) {
          JSEvents._removeHandler(i--);
        }
      }
    }
    return 0;
  },
  getNodeNameForTarget: function getNodeNameForTarget(target) {
    if (!target) return "";
    if (target == window) return "#window";
    if (target == screen) return "#screen";
    return (target === null || target === void 0 ? void 0 : target.nodeName) || "";
  },
  fullscreenEnabled: function fullscreenEnabled() {
    return document.fullscreenEnabled || document.mozFullScreenEnabled || document.webkitFullscreenEnabled;
  }
};
function _dmSysOpenURL(url, target) {
  var jsurl = UTF8ToString(url);
  var jstarget = UTF8ToString(target);
  if (jstarget == 0) {
    jstarget = "_self";
  }
  if (window.open(jsurl, jstarget) == null) {
    window.location = jsurl;
  }
  return true;
}
var readEmAsmArgsArray = [];
var readEmAsmArgs = function readEmAsmArgs(sigPtr, buf) {
  readEmAsmArgsArray.length = 0;
  var ch;
  while (ch = HEAPU8[sigPtr++]) {
    var wide = ch != 105;
    wide &= ch != 112;
    buf += wide && buf % 8 ? 4 : 0;
    readEmAsmArgsArray.push(ch == 112 ? HEAPU32[buf >> 2] : ch == 105 ? HEAP32[buf >> 2] : HEAPF64[buf >> 3]);
    buf += wide ? 8 : 4;
  }
  return readEmAsmArgsArray;
};
var runEmAsmFunction = function runEmAsmFunction(code, sigPtr, argbuf) {
  var args = readEmAsmArgs(sigPtr, argbuf);
  return ASM_CONSTS[code].apply(ASM_CONSTS, _toConsumableArray(args));
};
var _emscripten_asm_const_int = function _emscripten_asm_const_int(code, sigPtr, argbuf) {
  return runEmAsmFunction(code, sigPtr, argbuf);
};
var _emscripten_set_main_loop_timing = function _emscripten_set_main_loop_timing(mode, value) {
  Browser.mainLoop.timingMode = mode;
  Browser.mainLoop.timingValue = value;
  if (!Browser.mainLoop.func) {
    return 1;
  }
  if (!Browser.mainLoop.running) {
    Browser.mainLoop.running = true;
  }
  if (mode == 0) {
    Browser.mainLoop.scheduler = function Browser_mainLoop_scheduler_setTimeout() {
      var timeUntilNextTick = Math.max(0, Browser.mainLoop.tickStartTime + value - _emscripten_get_now()) | 0;
      setTimeout(Browser.mainLoop.runner, timeUntilNextTick);
    };
    Browser.mainLoop.method = "timeout";
  } else if (mode == 1) {
    Browser.mainLoop.scheduler = function Browser_mainLoop_scheduler_rAF() {
      Browser.requestAnimationFrame(Browser.mainLoop.runner);
    };
    Browser.mainLoop.method = "rAF";
  } else if (mode == 2) {
    if (typeof Browser.setImmediate == "undefined") {
      if (typeof setImmediate == "undefined") {
        var setImmediates = [];
        var emscriptenMainLoopMessageId = "setimmediate";
        var Browser_setImmediate_messageHandler = function Browser_setImmediate_messageHandler(event) {
          if (event.data === emscriptenMainLoopMessageId || event.data.target === emscriptenMainLoopMessageId) {
            event.stopPropagation();
            setImmediates.shift()();
          }
        };
        addEventListener("message", Browser_setImmediate_messageHandler, true);
        Browser.setImmediate = function Browser_emulated_setImmediate(func) {
          setImmediates.push(func);
          if (ENVIRONMENT_IS_WORKER) {
            if (Module["setImmediates"] === undefined) Module["setImmediates"] = [];
            Module["setImmediates"].push(func);
            postMessage({
              target: emscriptenMainLoopMessageId
            });
          } else postMessage(emscriptenMainLoopMessageId, "*");
        };
      } else {
        Browser.setImmediate = setImmediate;
      }
    }
    Browser.mainLoop.scheduler = function Browser_mainLoop_scheduler_setImmediate() {
      Browser.setImmediate(Browser.mainLoop.runner);
    };
    Browser.mainLoop.method = "immediate";
  }
  return 0;
};
var _emscripten_get_now;
_emscripten_get_now = function _emscripten_get_now() {
  return performance.now();
};
var setMainLoop = function setMainLoop(browserIterationFunc, fps, simulateInfiniteLoop, arg, noSetTiming) {
  Browser.mainLoop.func = browserIterationFunc;
  Browser.mainLoop.arg = arg;
  var thisMainLoopId = Browser.mainLoop.currentlyRunningMainloop;
  function checkIsRunning() {
    if (thisMainLoopId < Browser.mainLoop.currentlyRunningMainloop) {
      return false;
    }
    return true;
  }
  Browser.mainLoop.running = false;
  Browser.mainLoop.runner = function Browser_mainLoop_runner() {
    var _SDL$audio, _SDL$audio$queueNewAu;
    if (ABORT) return;
    if (Browser.mainLoop.queue.length > 0) {
      var start = Date.now();
      var blocker = Browser.mainLoop.queue.shift();
      blocker.func(blocker.arg);
      if (Browser.mainLoop.remainingBlockers) {
        var remaining = Browser.mainLoop.remainingBlockers;
        var next = remaining % 1 == 0 ? remaining - 1 : Math.floor(remaining);
        if (blocker.counted) {
          Browser.mainLoop.remainingBlockers = next;
        } else {
          next = next + .5;
          Browser.mainLoop.remainingBlockers = (8 * remaining + next) / 9;
        }
      }
      Browser.mainLoop.updateStatus();
      if (!checkIsRunning()) return;
      setTimeout(Browser.mainLoop.runner, 0);
      return;
    }
    if (!checkIsRunning()) return;
    Browser.mainLoop.currentFrameNumber = Browser.mainLoop.currentFrameNumber + 1 | 0;
    if (Browser.mainLoop.timingMode == 1 && Browser.mainLoop.timingValue > 1 && Browser.mainLoop.currentFrameNumber % Browser.mainLoop.timingValue != 0) {
      Browser.mainLoop.scheduler();
      return;
    } else if (Browser.mainLoop.timingMode == 0) {
      Browser.mainLoop.tickStartTime = _emscripten_get_now();
    }
    Browser.mainLoop.runIter(browserIterationFunc);
    if (!checkIsRunning()) return;
    if ((typeof SDL === "undefined" ? "undefined" : _typeof(SDL)) == "object") (_SDL$audio = SDL.audio) === null || _SDL$audio === void 0 || (_SDL$audio$queueNewAu = _SDL$audio.queueNewAudioData) === null || _SDL$audio$queueNewAu === void 0 || _SDL$audio$queueNewAu.call(_SDL$audio);
    Browser.mainLoop.scheduler();
  };
  if (!noSetTiming) {
    if (fps && fps > 0) {
      _emscripten_set_main_loop_timing(0, 1e3 / fps);
    } else {
      _emscripten_set_main_loop_timing(1, 1);
    }
    Browser.mainLoop.scheduler();
  }
  if (simulateInfiniteLoop) {
    throw "unwind";
  }
};
var handleException = function handleException(e) {
  if (e instanceof ExitStatus || e == "unwind") {
    return EXITSTATUS;
  }
  quit_(1, e);
};
var runtimeKeepaliveCounter = 0;
var keepRuntimeAlive = function keepRuntimeAlive() {
  return noExitRuntime || runtimeKeepaliveCounter > 0;
};
var _proc_exit = function _proc_exit(code) {
  EXITSTATUS = code;
  if (!keepRuntimeAlive()) {
    var _Module$onExit;
    (_Module$onExit = Module["onExit"]) === null || _Module$onExit === void 0 || _Module$onExit.call(Module, code);
    ABORT = true;
  }
  quit_(code, new ExitStatus(code));
};
var exitJS = function exitJS(status, implicit) {
  EXITSTATUS = status;
  _proc_exit(status);
};
var _exit = exitJS;
var maybeExit = function maybeExit() {
  if (!keepRuntimeAlive()) {
    try {
      _exit(EXITSTATUS);
    } catch (e) {
      handleException(e);
    }
  }
};
var callUserCallback = function callUserCallback(func) {
  if (ABORT) {
    return;
  }
  try {
    func();
    maybeExit();
  } catch (e) {
    handleException(e);
  }
};
var _safeSetTimeout = function safeSetTimeout(func, timeout) {
  return setTimeout(function () {
    callUserCallback(func);
  }, timeout);
};
var warnOnce = function warnOnce(text) {
  warnOnce.shown || (warnOnce.shown = {});
  if (!warnOnce.shown[text]) {
    warnOnce.shown[text] = 1;
    if (ENVIRONMENT_IS_NODE) text = "warning: " + text;
    err(text);
  }
};
var Browser = {
  mainLoop: {
    running: false,
    scheduler: null,
    method: "",
    currentlyRunningMainloop: 0,
    func: null,
    arg: 0,
    timingMode: 0,
    timingValue: 0,
    currentFrameNumber: 0,
    queue: [],
    pause: function pause() {
      Browser.mainLoop.scheduler = null;
      Browser.mainLoop.currentlyRunningMainloop++;
    },
    resume: function resume() {
      Browser.mainLoop.currentlyRunningMainloop++;
      var timingMode = Browser.mainLoop.timingMode;
      var timingValue = Browser.mainLoop.timingValue;
      var func = Browser.mainLoop.func;
      Browser.mainLoop.func = null;
      setMainLoop(func, 0, false, Browser.mainLoop.arg, true);
      _emscripten_set_main_loop_timing(timingMode, timingValue);
      Browser.mainLoop.scheduler();
    },
    updateStatus: function updateStatus() {
      if (Module["setStatus"]) {
        var message = Module["statusMessage"] || "Please wait...";
        var remaining = Browser.mainLoop.remainingBlockers;
        var expected = Browser.mainLoop.expectedBlockers;
        if (remaining) {
          if (remaining < expected) {
            Module["setStatus"]("{message} ({expected - remaining}/{expected})");
          } else {
            Module["setStatus"](message);
          }
        } else {
          Module["setStatus"]("");
        }
      }
    },
    runIter: function runIter(func) {
      var _Module$postMainLoop;
      if (ABORT) return;
      if (Module["preMainLoop"]) {
        var preRet = Module["preMainLoop"]();
        if (preRet === false) {
          return;
        }
      }
      callUserCallback(func);
      (_Module$postMainLoop = Module["postMainLoop"]) === null || _Module$postMainLoop === void 0 || _Module$postMainLoop.call(Module);
    }
  },
  isFullscreen: false,
  pointerLock: false,
  moduleContextCreatedCallbacks: [],
  workers: [],
  init: function init() {
    if (Browser.initted) return;
    Browser.initted = true;
    var imagePlugin = {};
    imagePlugin["canHandle"] = function imagePlugin_canHandle(name) {
      return !Module.noImageDecoding && /\.(jpg|jpeg|png|bmp)$/i.test(name);
    };
    imagePlugin["handle"] = function imagePlugin_handle(byteArray, name, onload, onerror) {
      var b = new Blob([byteArray], {
        type: Browser.getMimetype(name)
      });
      if (b.size !== byteArray.length) {
        b = new Blob([new Uint8Array(byteArray).buffer], {
          type: Browser.getMimetype(name)
        });
      }
      var url = URL.createObjectURL(b);
      var img = new Image();
      img.onload = function () {
        var canvas = document.createElement("canvas");
        canvas.width = img.width;
        canvas.height = img.height;
        var ctx = canvas.getContext("2d");
        ctx.drawImage(img, 0, 0);
        preloadedImages[name] = canvas;
        URL.revokeObjectURL(url);
        onload === null || onload === void 0 || onload(byteArray);
      };
      img.onerror = function (event) {
        err("Image ".concat(url, " could not be decoded"));
        onerror === null || onerror === void 0 || onerror();
      };
      img.src = url;
    };
    preloadPlugins.push(imagePlugin);
    var audioPlugin = {};
    audioPlugin["canHandle"] = function audioPlugin_canHandle(name) {
      return !Module.noAudioDecoding && name.substr(-4) in {
        ".ogg": 1,
        ".wav": 1,
        ".mp3": 1
      };
    };
    audioPlugin["handle"] = function audioPlugin_handle(byteArray, name, onload, onerror) {
      var done = false;
      function finish(audio) {
        if (done) return;
        done = true;
        preloadedAudios[name] = audio;
        onload === null || onload === void 0 || onload(byteArray);
      }
      var b = new Blob([byteArray], {
        type: Browser.getMimetype(name)
      });
      var url = URL.createObjectURL(b);
      var audio = new Audio();
      audio.addEventListener("canplaythrough", function () {
        return finish(audio);
      }, false);
      audio.onerror = function audio_onerror(event) {
        if (done) return;
        err("warning: browser could not fully decode audio ".concat(name, ", trying slower base64 approach"));
        function encode64(data) {
          var BASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
          var PAD = "=";
          var ret = "";
          var leftchar = 0;
          var leftbits = 0;
          for (var i = 0; i < data.length; i++) {
            leftchar = leftchar << 8 | data[i];
            leftbits += 8;
            while (leftbits >= 6) {
              var curr = leftchar >> leftbits - 6 & 63;
              leftbits -= 6;
              ret += BASE[curr];
            }
          }
          if (leftbits == 2) {
            ret += BASE[(leftchar & 3) << 4];
            ret += PAD + PAD;
          } else if (leftbits == 4) {
            ret += BASE[(leftchar & 15) << 2];
            ret += PAD;
          }
          return ret;
        }
        audio.src = "data:audio/x-" + name.substr(-3) + ";base64," + encode64(byteArray);
        finish(audio);
      };
      audio.src = url;
      _safeSetTimeout(function () {
        finish(audio);
      }, 1e4);
    };
    preloadPlugins.push(audioPlugin);
    function pointerLockChange() {
      Browser.pointerLock = document["pointerLockElement"] === Module["canvas"] || document["mozPointerLockElement"] === Module["canvas"] || document["webkitPointerLockElement"] === Module["canvas"] || document["msPointerLockElement"] === Module["canvas"];
    }
    var canvas = Module["canvas"];
    if (canvas) {
      canvas.requestPointerLock = canvas["requestPointerLock"] || canvas["mozRequestPointerLock"] || canvas["webkitRequestPointerLock"] || canvas["msRequestPointerLock"] || function () {};
      canvas.exitPointerLock = document["exitPointerLock"] || document["mozExitPointerLock"] || document["webkitExitPointerLock"] || document["msExitPointerLock"] || function () {};
      canvas.exitPointerLock = canvas.exitPointerLock.bind(document);
      document.addEventListener("pointerlockchange", pointerLockChange, false);
      document.addEventListener("mozpointerlockchange", pointerLockChange, false);
      document.addEventListener("webkitpointerlockchange", pointerLockChange, false);
      document.addEventListener("mspointerlockchange", pointerLockChange, false);
      if (Module["elementPointerLock"]) {
        canvas.addEventListener("click", function (ev) {
          if (!Browser.pointerLock && Module["canvas"].requestPointerLock) {
            Module["canvas"].requestPointerLock();
            ev.preventDefault();
          }
        }, false);
      }
    }
  },
  createContext: function createContext(canvas, useWebGL, setInModule, webGLContextAttributes) {
    if (useWebGL && Module.ctx && canvas == Module.canvas) return Module.ctx;
    var ctx;
    var contextHandle;
    if (useWebGL) {
      var contextAttributes = {
        antialias: false,
        alpha: false,
        majorVersion: typeof WebGL2RenderingContext != "undefined" ? 2 : 1
      };
      if (webGLContextAttributes) {
        for (var attribute in webGLContextAttributes) {
          contextAttributes[attribute] = webGLContextAttributes[attribute];
        }
      }
      if (typeof GL != "undefined") {
        contextHandle = GL.createContext(canvas, contextAttributes);
        if (contextHandle) {
          ctx = GL.getContext(contextHandle).GLctx;
        }
      }
    } else {
      ctx = canvas.getContext("2d");
    }
    if (!ctx) return null;
    if (setInModule) {
      Module.ctx = ctx;
      if (useWebGL) GL.makeContextCurrent(contextHandle);
      Module.useWebGL = useWebGL;
      Browser.moduleContextCreatedCallbacks.forEach(function (callback) {
        return callback();
      });
      Browser.init();
    }
    return ctx;
  },
  destroyContext: function destroyContext(canvas, useWebGL, setInModule) {},
  fullscreenHandlersInstalled: false,
  lockPointer: undefined,
  resizeCanvas: undefined,
  requestFullscreen: function requestFullscreen(lockPointer, resizeCanvas) {
    Browser.lockPointer = lockPointer;
    Browser.resizeCanvas = resizeCanvas;
    if (typeof Browser.lockPointer == "undefined") Browser.lockPointer = true;
    if (typeof Browser.resizeCanvas == "undefined") Browser.resizeCanvas = false;
    var canvas = Module["canvas"];
    function fullscreenChange() {
      var _Module$onFullScreen, _Module$onFullscreen;
      Browser.isFullscreen = false;
      var canvasContainer = canvas.parentNode;
      if ((document["fullscreenElement"] || document["mozFullScreenElement"] || document["msFullscreenElement"] || document["webkitFullscreenElement"] || document["webkitCurrentFullScreenElement"]) === canvasContainer) {
        canvas.exitFullscreen = Browser.exitFullscreen;
        if (Browser.lockPointer) canvas.requestPointerLock();
        Browser.isFullscreen = true;
        if (Browser.resizeCanvas) {
          Browser.setFullscreenCanvasSize();
        } else {
          Browser.updateCanvasDimensions(canvas);
        }
      } else {
        canvasContainer.parentNode.insertBefore(canvas, canvasContainer);
        canvasContainer.parentNode.removeChild(canvasContainer);
        if (Browser.resizeCanvas) {
          Browser.setWindowedCanvasSize();
        } else {
          Browser.updateCanvasDimensions(canvas);
        }
      }
      (_Module$onFullScreen = Module["onFullScreen"]) === null || _Module$onFullScreen === void 0 || _Module$onFullScreen.call(Module, Browser.isFullscreen);
      (_Module$onFullscreen = Module["onFullscreen"]) === null || _Module$onFullscreen === void 0 || _Module$onFullscreen.call(Module, Browser.isFullscreen);
    }
    if (!Browser.fullscreenHandlersInstalled) {
      Browser.fullscreenHandlersInstalled = true;
      document.addEventListener("fullscreenchange", fullscreenChange, false);
      document.addEventListener("mozfullscreenchange", fullscreenChange, false);
      document.addEventListener("webkitfullscreenchange", fullscreenChange, false);
      document.addEventListener("MSFullscreenChange", fullscreenChange, false);
    }
    var canvasContainer = document.createElement("div");
    canvas.parentNode.insertBefore(canvasContainer, canvas);
    canvasContainer.appendChild(canvas);
    canvasContainer.requestFullscreen = canvasContainer["requestFullscreen"] || canvasContainer["mozRequestFullScreen"] || canvasContainer["msRequestFullscreen"] || (canvasContainer["webkitRequestFullscreen"] ? function () {
      return canvasContainer["webkitRequestFullscreen"](Element["ALLOW_KEYBOARD_INPUT"]);
    } : null) || (canvasContainer["webkitRequestFullScreen"] ? function () {
      return canvasContainer["webkitRequestFullScreen"](Element["ALLOW_KEYBOARD_INPUT"]);
    } : null);
    canvasContainer.requestFullscreen();
  },
  exitFullscreen: function exitFullscreen() {
    if (!Browser.isFullscreen) {
      return false;
    }
    var CFS = document["exitFullscreen"] || document["cancelFullScreen"] || document["mozCancelFullScreen"] || document["msExitFullscreen"] || document["webkitCancelFullScreen"] || function () {};
    CFS.apply(document, []);
    return true;
  },
  nextRAF: 0,
  fakeRequestAnimationFrame: function fakeRequestAnimationFrame(func) {
    var now = Date.now();
    if (Browser.nextRAF === 0) {
      Browser.nextRAF = now + 1e3 / 60;
    } else {
      while (now + 2 >= Browser.nextRAF) {
        Browser.nextRAF += 1e3 / 60;
      }
    }
    var delay = Math.max(Browser.nextRAF - now, 0);
    setTimeout(func, delay);
  },
  requestAnimationFrame: function (_requestAnimationFrame) {
    function requestAnimationFrame(_x) {
      return _requestAnimationFrame.apply(this, arguments);
    }
    requestAnimationFrame.toString = function () {
      return _requestAnimationFrame.toString();
    };
    return requestAnimationFrame;
  }(function (func) {
    if (typeof requestAnimationFrame == "function") {
      requestAnimationFrame(func);
      return;
    }
    var RAF = Browser.fakeRequestAnimationFrame;
    RAF(func);
  }),
  safeSetTimeout: function safeSetTimeout(func, timeout) {
    return _safeSetTimeout(func, timeout);
  },
  safeRequestAnimationFrame: function safeRequestAnimationFrame(func) {
    return Browser.requestAnimationFrame(function () {
      callUserCallback(func);
    });
  },
  getMimetype: function getMimetype(name) {
    return {
      "jpg": "image/jpeg",
      "jpeg": "image/jpeg",
      "png": "image/png",
      "bmp": "image/bmp",
      "ogg": "audio/ogg",
      "wav": "audio/wav",
      "mp3": "audio/mpeg"
    }[name.substr(name.lastIndexOf(".") + 1)];
  },
  getUserMedia: function getUserMedia(func) {
    var _window;
    (_window = window).getUserMedia || (_window.getUserMedia = navigator["getUserMedia"] || navigator["mozGetUserMedia"]);
    window.getUserMedia(func);
  },
  getMovementX: function getMovementX(event) {
    return event["movementX"] || event["mozMovementX"] || event["webkitMovementX"] || 0;
  },
  getMovementY: function getMovementY(event) {
    return event["movementY"] || event["mozMovementY"] || event["webkitMovementY"] || 0;
  },
  getMouseWheelDelta: function getMouseWheelDelta(event) {
    var delta = 0;
    switch (event.type) {
      case "DOMMouseScroll":
        delta = event.detail / 3;
        break;
      case "mousewheel":
        delta = event.wheelDelta / 120;
        break;
      case "wheel":
        delta = event.deltaY;
        switch (event.deltaMode) {
          case 0:
            delta /= 100;
            break;
          case 1:
            delta /= 3;
            break;
          case 2:
            delta *= 80;
            break;
          default:
            throw "unrecognized mouse wheel delta mode: " + event.deltaMode;
        }
        break;
      default:
        throw "unrecognized mouse wheel event: " + event.type;
    }
    return delta;
  },
  mouseX: 0,
  mouseY: 0,
  mouseMovementX: 0,
  mouseMovementY: 0,
  touches: {},
  lastTouches: {},
  calculateMouseCoords: function calculateMouseCoords(pageX, pageY) {
    var rect = Module["canvas"].getBoundingClientRect();
    var cw = Module["canvas"].width;
    var ch = Module["canvas"].height;
    var scrollX = typeof window.scrollX != "undefined" ? window.scrollX : window.pageXOffset;
    var scrollY = typeof window.scrollY != "undefined" ? window.scrollY : window.pageYOffset;
    var adjustedX = pageX - (scrollX + rect.left);
    var adjustedY = pageY - (scrollY + rect.top);
    adjustedX = adjustedX * (cw / rect.width);
    adjustedY = adjustedY * (ch / rect.height);
    return {
      x: adjustedX,
      y: adjustedY
    };
  },
  setMouseCoords: function setMouseCoords(pageX, pageY) {
    var _Browser$calculateMou = Browser.calculateMouseCoords(pageX, pageY),
      x = _Browser$calculateMou.x,
      y = _Browser$calculateMou.y;
    Browser.mouseMovementX = x - Browser.mouseX;
    Browser.mouseMovementY = y - Browser.mouseY;
    Browser.mouseX = x;
    Browser.mouseY = y;
  },
  calculateMouseEvent: function calculateMouseEvent(event) {
    if (Browser.pointerLock) {
      if (event.type != "mousemove" && "mozMovementX" in event) {
        Browser.mouseMovementX = Browser.mouseMovementY = 0;
      } else {
        Browser.mouseMovementX = Browser.getMovementX(event);
        Browser.mouseMovementY = Browser.getMovementY(event);
      }
      if (typeof SDL != "undefined") {
        Browser.mouseX = SDL.mouseX + Browser.mouseMovementX;
        Browser.mouseY = SDL.mouseY + Browser.mouseMovementY;
      } else {
        Browser.mouseX += Browser.mouseMovementX;
        Browser.mouseY += Browser.mouseMovementY;
      }
    } else {
      if (event.type === "touchstart" || event.type === "touchend" || event.type === "touchmove") {
        var touch = event.touch;
        if (touch === undefined) {
          return;
        }
        var coords = Browser.calculateMouseCoords(touch.pageX, touch.pageY);
        if (event.type === "touchstart") {
          Browser.lastTouches[touch.identifier] = coords;
          Browser.touches[touch.identifier] = coords;
        } else if (event.type === "touchend" || event.type === "touchmove") {
          var last = Browser.touches[touch.identifier];
          last || (last = coords);
          Browser.lastTouches[touch.identifier] = last;
          Browser.touches[touch.identifier] = coords;
        }
        return;
      }
      Browser.setMouseCoords(event.pageX, event.pageY);
    }
  },
  resizeListeners: [],
  updateResizeListeners: function updateResizeListeners() {
    var canvas = Module["canvas"];
    Browser.resizeListeners.forEach(function (listener) {
      return listener(canvas.width, canvas.height);
    });
  },
  setCanvasSize: function setCanvasSize(width, height, noUpdates) {
    var canvas = Module["canvas"];
    Browser.updateCanvasDimensions(canvas, width, height);
    if (!noUpdates) Browser.updateResizeListeners();
  },
  windowedWidth: 0,
  windowedHeight: 0,
  setFullscreenCanvasSize: function setFullscreenCanvasSize() {
    if (typeof SDL != "undefined") {
      var flags = HEAPU32[SDL.screen >> 2];
      flags = flags | 8388608;
      HEAP32[SDL.screen >> 2] = flags;
    }
    Browser.updateCanvasDimensions(Module["canvas"]);
    Browser.updateResizeListeners();
  },
  setWindowedCanvasSize: function setWindowedCanvasSize() {
    if (typeof SDL != "undefined") {
      var flags = HEAPU32[SDL.screen >> 2];
      flags = flags & ~8388608;
      HEAP32[SDL.screen >> 2] = flags;
    }
    Browser.updateCanvasDimensions(Module["canvas"]);
    Browser.updateResizeListeners();
  },
  updateCanvasDimensions: function updateCanvasDimensions(canvas, wNative, hNative) {
    if (wNative && hNative) {
      canvas.widthNative = wNative;
      canvas.heightNative = hNative;
    } else {
      wNative = canvas.widthNative;
      hNative = canvas.heightNative;
    }
    var w = wNative;
    var h = hNative;
    if (Module["forcedAspectRatio"] && Module["forcedAspectRatio"] > 0) {
      if (w / h < Module["forcedAspectRatio"]) {
        w = Math.round(h * Module["forcedAspectRatio"]);
      } else {
        h = Math.round(w / Module["forcedAspectRatio"]);
      }
    }
    if ((document["fullscreenElement"] || document["mozFullScreenElement"] || document["msFullscreenElement"] || document["webkitFullscreenElement"] || document["webkitCurrentFullScreenElement"]) === canvas.parentNode && typeof screen != "undefined") {
      var factor = Math.min(screen.width / w, screen.height / h);
      w = Math.round(w * factor);
      h = Math.round(h * factor);
    }
    if (Browser.resizeCanvas) {
      if (canvas.width != w) canvas.width = w;
      if (canvas.height != h) canvas.height = h;
      if (typeof canvas.style != "undefined") {
        canvas.style.removeProperty("width");
        canvas.style.removeProperty("height");
      }
    } else {
      if (canvas.width != wNative) canvas.width = wNative;
      if (canvas.height != hNative) canvas.height = hNative;
      if (typeof canvas.style != "undefined") {
        if (w != wNative || h != hNative) {
          canvas.style.setProperty("width", w + "px", "important");
          canvas.style.setProperty("height", h + "px", "important");
        } else {
          canvas.style.removeProperty("width");
          canvas.style.removeProperty("height");
        }
      }
    }
  }
};
var _emscripten_cancel_main_loop = function _emscripten_cancel_main_loop() {
  Browser.mainLoop.pause();
  Browser.mainLoop.func = null;
};
var _emscripten_date_now = function _emscripten_date_now() {
  return Date.now();
};
var getHeapMax = function getHeapMax() {
  return 2147483648;
};
var _emscripten_get_heap_max = function _emscripten_get_heap_max() {
  return getHeapMax();
};
var GL = {
  counter: 1,
  buffers: [],
  programs: [],
  framebuffers: [],
  renderbuffers: [],
  textures: [],
  shaders: [],
  vaos: [],
  contexts: [],
  offscreenCanvases: {},
  queries: [],
  samplers: [],
  transformFeedbacks: [],
  syncs: [],
  stringCache: {},
  stringiCache: {},
  unpackAlignment: 4,
  recordError: function recordError(errorCode) {
    if (!GL.lastError) {
      GL.lastError = errorCode;
    }
  },
  getNewId: function getNewId(table) {
    var ret = GL.counter++;
    for (var i = table.length; i < ret; i++) {
      table[i] = null;
    }
    return ret;
  },
  genObject: function genObject(n, buffers, createFunction, objectTable) {
    for (var i = 0; i < n; i++) {
      var buffer = GLctx[createFunction]();
      var id = buffer && GL.getNewId(objectTable);
      if (buffer) {
        buffer.name = id;
        objectTable[id] = buffer;
      } else {
        GL.recordError(1282);
      }
      HEAP32[buffers + i * 4 >> 2] = id;
    }
  },
  getSource: function getSource(shader, count, string, length) {
    var source = "";
    for (var i = 0; i < count; ++i) {
      var len = length ? HEAPU32[length + i * 4 >> 2] : undefined;
      source += UTF8ToString(HEAPU32[string + i * 4 >> 2], len);
    }
    return source;
  },
  createContext: function createContext(canvas, webGLContextAttributes) {
    function getChromeVersion() {
      var chromeVersion = navigator.userAgent.match(/Chrom(e|ium)\/([0-9]+)\./);
      if (chromeVersion) return chromeVersion[2] | 0;
    }
    if (!canvas.getContextSafariWebGL2Fixed) {
      var fixedGetContext = function fixedGetContext(ver, attrs) {
        var gl = canvas.getContextSafariWebGL2Fixed(ver, attrs);
        return ver == "webgl" == gl instanceof WebGLRenderingContext ? gl : null;
      };
      canvas.getContextSafariWebGL2Fixed = canvas.getContext;
      canvas.getContext = fixedGetContext;
    }
    var ctx = webGLContextAttributes.majorVersion > 1 ? !(getChromeVersion() <= 57) && canvas.getContext("webgl2", webGLContextAttributes) : canvas.getContext("webgl", webGLContextAttributes) || canvas.getContext("experimental-webgl", webGLContextAttributes);
    if (!ctx) return 0;
    var handle = GL.registerContext(ctx, webGLContextAttributes);
    return handle;
  },
  registerContext: function registerContext(ctx, webGLContextAttributes) {
    var handle = GL.getNewId(GL.contexts);
    var context = {
      handle: handle,
      attributes: webGLContextAttributes,
      version: webGLContextAttributes.majorVersion,
      GLctx: ctx
    };
    if (ctx.canvas) ctx.canvas.GLctxObject = context;
    GL.contexts[handle] = context;
    return handle;
  },
  makeContextCurrent: function makeContextCurrent(contextHandle) {
    var _GL$currentContext;
    GL.currentContext = GL.contexts[contextHandle];
    Module.ctx = GLctx = (_GL$currentContext = GL.currentContext) === null || _GL$currentContext === void 0 ? void 0 : _GL$currentContext.GLctx;
    return !(contextHandle && !GLctx);
  },
  getContext: function getContext(contextHandle) {
    return GL.contexts[contextHandle];
  },
  deleteContext: function deleteContext(contextHandle) {
    if (GL.currentContext === GL.contexts[contextHandle]) {
      GL.currentContext = null;
    }
    if (_typeof(JSEvents) == "object") {
      JSEvents.removeAllHandlersOnTarget(GL.contexts[contextHandle].GLctx.canvas);
    }
    if (GL.contexts[contextHandle] && GL.contexts[contextHandle].GLctx.canvas) {
      GL.contexts[contextHandle].GLctx.canvas.GLctxObject = undefined;
    }
    GL.contexts[contextHandle] = null;
  }
};
var _glActiveTexture = function _glActiveTexture(x0) {
  return GLctx.activeTexture(x0);
};
var _emscripten_glActiveTexture = _glActiveTexture;
var _glAttachShader = function _glAttachShader(program, shader) {
  GLctx.attachShader(GL.programs[program], GL.shaders[shader]);
};
var _emscripten_glAttachShader = _glAttachShader;
var _glBeginQuery = function _glBeginQuery(target, id) {
  GLctx.beginQuery(target, GL.queries[id]);
};
var _emscripten_glBeginQuery = _glBeginQuery;
var _glBeginQueryEXT = function _glBeginQueryEXT(target, id) {
  GLctx.disjointTimerQueryExt["beginQueryEXT"](target, GL.queries[id]);
};
var _emscripten_glBeginQueryEXT = _glBeginQueryEXT;
var _glBeginTransformFeedback = function _glBeginTransformFeedback(x0) {
  return GLctx.beginTransformFeedback(x0);
};
var _emscripten_glBeginTransformFeedback = _glBeginTransformFeedback;
var _glBindAttribLocation = function _glBindAttribLocation(program, index, name) {
  GLctx.bindAttribLocation(GL.programs[program], index, UTF8ToString(name));
};
var _emscripten_glBindAttribLocation = _glBindAttribLocation;
var _glBindBuffer = function _glBindBuffer(target, buffer) {
  if (target == 35051) {
    GLctx.currentPixelPackBufferBinding = buffer;
  } else if (target == 35052) {
    GLctx.currentPixelUnpackBufferBinding = buffer;
  }
  GLctx.bindBuffer(target, GL.buffers[buffer]);
};
var _emscripten_glBindBuffer = _glBindBuffer;
var _glBindBufferBase = function _glBindBufferBase(target, index, buffer) {
  GLctx.bindBufferBase(target, index, GL.buffers[buffer]);
};
var _emscripten_glBindBufferBase = _glBindBufferBase;
var _glBindBufferRange = function _glBindBufferRange(target, index, buffer, offset, ptrsize) {
  GLctx.bindBufferRange(target, index, GL.buffers[buffer], offset, ptrsize);
};
var _emscripten_glBindBufferRange = _glBindBufferRange;
var _glBindFramebuffer = function _glBindFramebuffer(target, framebuffer) {
  GLctx.bindFramebuffer(target, GL.framebuffers[framebuffer]);
};
var _emscripten_glBindFramebuffer = _glBindFramebuffer;
var _glBindRenderbuffer = function _glBindRenderbuffer(target, renderbuffer) {
  GLctx.bindRenderbuffer(target, GL.renderbuffers[renderbuffer]);
};
var _emscripten_glBindRenderbuffer = _glBindRenderbuffer;
var _glBindSampler = function _glBindSampler(unit, sampler) {
  GLctx.bindSampler(unit, GL.samplers[sampler]);
};
var _emscripten_glBindSampler = _glBindSampler;
var _glBindTexture = function _glBindTexture(target, texture) {
  GLctx.bindTexture(target, GL.textures[texture]);
};
var _emscripten_glBindTexture = _glBindTexture;
var _glBindTransformFeedback = function _glBindTransformFeedback(target, id) {
  GLctx.bindTransformFeedback(target, GL.transformFeedbacks[id]);
};
var _emscripten_glBindTransformFeedback = _glBindTransformFeedback;
var _glBindVertexArray = function _glBindVertexArray(vao) {
  GLctx.bindVertexArray(GL.vaos[vao]);
};
var _emscripten_glBindVertexArray = _glBindVertexArray;
var _glBindVertexArrayOES = _glBindVertexArray;
var _emscripten_glBindVertexArrayOES = _glBindVertexArrayOES;
var _glBlendColor = function _glBlendColor(x0, x1, x2, x3) {
  return GLctx.blendColor(x0, x1, x2, x3);
};
var _emscripten_glBlendColor = _glBlendColor;
var _glBlendEquation = function _glBlendEquation(x0) {
  return GLctx.blendEquation(x0);
};
var _emscripten_glBlendEquation = _glBlendEquation;
var _glBlendEquationSeparate = function _glBlendEquationSeparate(x0, x1) {
  return GLctx.blendEquationSeparate(x0, x1);
};
var _emscripten_glBlendEquationSeparate = _glBlendEquationSeparate;
var _glBlendFunc = function _glBlendFunc(x0, x1) {
  return GLctx.blendFunc(x0, x1);
};
var _emscripten_glBlendFunc = _glBlendFunc;
var _glBlendFuncSeparate = function _glBlendFuncSeparate(x0, x1, x2, x3) {
  return GLctx.blendFuncSeparate(x0, x1, x2, x3);
};
var _emscripten_glBlendFuncSeparate = _glBlendFuncSeparate;
var _glBlitFramebuffer = function _glBlitFramebuffer(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9) {
  return GLctx.blitFramebuffer(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9);
};
var _emscripten_glBlitFramebuffer = _glBlitFramebuffer;
var _glBufferData = function _glBufferData(target, size, data, usage) {
  if (GL.currentContext.version >= 2) {
    if (data && size) {
      GLctx.bufferData(target, HEAPU8, usage, data, size);
    } else {
      GLctx.bufferData(target, size, usage);
    }
    return;
  }
  GLctx.bufferData(target, data ? HEAPU8.subarray(data, data + size) : size, usage);
};
var _emscripten_glBufferData = _glBufferData;
var _glBufferSubData = function _glBufferSubData(target, offset, size, data) {
  if (GL.currentContext.version >= 2) {
    size && GLctx.bufferSubData(target, offset, HEAPU8, data, size);
    return;
  }
  GLctx.bufferSubData(target, offset, HEAPU8.subarray(data, data + size));
};
var _emscripten_glBufferSubData = _glBufferSubData;
var _glCheckFramebufferStatus = function _glCheckFramebufferStatus(x0) {
  return GLctx.checkFramebufferStatus(x0);
};
var _emscripten_glCheckFramebufferStatus = _glCheckFramebufferStatus;
var _glClear = function _glClear(x0) {
  return GLctx.clear(x0);
};
var _emscripten_glClear = _glClear;
var _glClearBufferfi = function _glClearBufferfi(x0, x1, x2, x3) {
  return GLctx.clearBufferfi(x0, x1, x2, x3);
};
var _emscripten_glClearBufferfi = _glClearBufferfi;
var _glClearBufferfv = function _glClearBufferfv(buffer, drawbuffer, value) {
  GLctx.clearBufferfv(buffer, drawbuffer, HEAPF32, value >> 2);
};
var _emscripten_glClearBufferfv = _glClearBufferfv;
var _glClearBufferiv = function _glClearBufferiv(buffer, drawbuffer, value) {
  GLctx.clearBufferiv(buffer, drawbuffer, HEAP32, value >> 2);
};
var _emscripten_glClearBufferiv = _glClearBufferiv;
var _glClearBufferuiv = function _glClearBufferuiv(buffer, drawbuffer, value) {
  GLctx.clearBufferuiv(buffer, drawbuffer, HEAPU32, value >> 2);
};
var _emscripten_glClearBufferuiv = _glClearBufferuiv;
var _glClearColor = function _glClearColor(x0, x1, x2, x3) {
  return GLctx.clearColor(x0, x1, x2, x3);
};
var _emscripten_glClearColor = _glClearColor;
var _glClearDepthf = function _glClearDepthf(x0) {
  return GLctx.clearDepth(x0);
};
var _emscripten_glClearDepthf = _glClearDepthf;
var _glClearStencil = function _glClearStencil(x0) {
  return GLctx.clearStencil(x0);
};
var _emscripten_glClearStencil = _glClearStencil;
var convertI32PairToI53 = function convertI32PairToI53(lo, hi) {
  return (lo >>> 0) + hi * 4294967296;
};
var _glClientWaitSync = function _glClientWaitSync(sync, flags, timeout_low, timeout_high) {
  var timeout = convertI32PairToI53(timeout_low, timeout_high);
  return GLctx.clientWaitSync(GL.syncs[sync], flags, timeout);
};
var _emscripten_glClientWaitSync = _glClientWaitSync;
var _glColorMask = function _glColorMask(red, green, blue, alpha) {
  GLctx.colorMask(!!red, !!green, !!blue, !!alpha);
};
var _emscripten_glColorMask = _glColorMask;
var _glCompileShader = function _glCompileShader(shader) {
  GLctx.compileShader(GL.shaders[shader]);
};
var _emscripten_glCompileShader = _glCompileShader;
var _glCompressedTexImage2D = function _glCompressedTexImage2D(target, level, internalFormat, width, height, border, imageSize, data) {
  if (GL.currentContext.version >= 2) {
    if (GLctx.currentPixelUnpackBufferBinding || !imageSize) {
      GLctx.compressedTexImage2D(target, level, internalFormat, width, height, border, imageSize, data);
    } else {
      GLctx.compressedTexImage2D(target, level, internalFormat, width, height, border, HEAPU8, data, imageSize);
    }
    return;
  }
  GLctx.compressedTexImage2D(target, level, internalFormat, width, height, border, data ? HEAPU8.subarray(data, data + imageSize) : null);
};
var _emscripten_glCompressedTexImage2D = _glCompressedTexImage2D;
var _glCompressedTexImage3D = function _glCompressedTexImage3D(target, level, internalFormat, width, height, depth, border, imageSize, data) {
  if (GLctx.currentPixelUnpackBufferBinding) {
    GLctx.compressedTexImage3D(target, level, internalFormat, width, height, depth, border, imageSize, data);
  } else {
    GLctx.compressedTexImage3D(target, level, internalFormat, width, height, depth, border, HEAPU8, data, imageSize);
  }
};
var _emscripten_glCompressedTexImage3D = _glCompressedTexImage3D;
var _glCompressedTexSubImage2D = function _glCompressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, imageSize, data) {
  if (GL.currentContext.version >= 2) {
    if (GLctx.currentPixelUnpackBufferBinding || !imageSize) {
      GLctx.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, imageSize, data);
    } else {
      GLctx.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, HEAPU8, data, imageSize);
    }
    return;
  }
  GLctx.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, data ? HEAPU8.subarray(data, data + imageSize) : null);
};
var _emscripten_glCompressedTexSubImage2D = _glCompressedTexSubImage2D;
var _glCompressedTexSubImage3D = function _glCompressedTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, data) {
  if (GLctx.currentPixelUnpackBufferBinding) {
    GLctx.compressedTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, imageSize, data);
  } else {
    GLctx.compressedTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, HEAPU8, data, imageSize);
  }
};
var _emscripten_glCompressedTexSubImage3D = _glCompressedTexSubImage3D;
var _glCopyBufferSubData = function _glCopyBufferSubData(x0, x1, x2, x3, x4) {
  return GLctx.copyBufferSubData(x0, x1, x2, x3, x4);
};
var _emscripten_glCopyBufferSubData = _glCopyBufferSubData;
var _glCopyTexImage2D = function _glCopyTexImage2D(x0, x1, x2, x3, x4, x5, x6, x7) {
  return GLctx.copyTexImage2D(x0, x1, x2, x3, x4, x5, x6, x7);
};
var _emscripten_glCopyTexImage2D = _glCopyTexImage2D;
var _glCopyTexSubImage2D = function _glCopyTexSubImage2D(x0, x1, x2, x3, x4, x5, x6, x7) {
  return GLctx.copyTexSubImage2D(x0, x1, x2, x3, x4, x5, x6, x7);
};
var _emscripten_glCopyTexSubImage2D = _glCopyTexSubImage2D;
var _glCopyTexSubImage3D = function _glCopyTexSubImage3D(x0, x1, x2, x3, x4, x5, x6, x7, x8) {
  return GLctx.copyTexSubImage3D(x0, x1, x2, x3, x4, x5, x6, x7, x8);
};
var _emscripten_glCopyTexSubImage3D = _glCopyTexSubImage3D;
var _glCreateProgram = function _glCreateProgram() {
  var id = GL.getNewId(GL.programs);
  var program = GLctx.createProgram();
  program.name = id;
  program.maxUniformLength = program.maxAttributeLength = program.maxUniformBlockNameLength = 0;
  program.uniformIdCounter = 1;
  GL.programs[id] = program;
  return id;
};
var _emscripten_glCreateProgram = _glCreateProgram;
var _glCreateShader = function _glCreateShader(shaderType) {
  var id = GL.getNewId(GL.shaders);
  GL.shaders[id] = GLctx.createShader(shaderType);
  return id;
};
var _emscripten_glCreateShader = _glCreateShader;
var _glCullFace = function _glCullFace(x0) {
  return GLctx.cullFace(x0);
};
var _emscripten_glCullFace = _glCullFace;
var _glDeleteBuffers = function _glDeleteBuffers(n, buffers) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[buffers + i * 4 >> 2];
    var buffer = GL.buffers[id];
    if (!buffer) continue;
    GLctx.deleteBuffer(buffer);
    buffer.name = 0;
    GL.buffers[id] = null;
    if (id == GLctx.currentPixelPackBufferBinding) GLctx.currentPixelPackBufferBinding = 0;
    if (id == GLctx.currentPixelUnpackBufferBinding) GLctx.currentPixelUnpackBufferBinding = 0;
  }
};
var _emscripten_glDeleteBuffers = _glDeleteBuffers;
var _glDeleteFramebuffers = function _glDeleteFramebuffers(n, framebuffers) {
  for (var i = 0; i < n; ++i) {
    var id = HEAP32[framebuffers + i * 4 >> 2];
    var framebuffer = GL.framebuffers[id];
    if (!framebuffer) continue;
    GLctx.deleteFramebuffer(framebuffer);
    framebuffer.name = 0;
    GL.framebuffers[id] = null;
  }
};
var _emscripten_glDeleteFramebuffers = _glDeleteFramebuffers;
var _glDeleteProgram = function _glDeleteProgram(id) {
  if (!id) return;
  var program = GL.programs[id];
  if (!program) {
    GL.recordError(1281);
    return;
  }
  GLctx.deleteProgram(program);
  program.name = 0;
  GL.programs[id] = null;
};
var _emscripten_glDeleteProgram = _glDeleteProgram;
var _glDeleteQueries = function _glDeleteQueries(n, ids) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[ids + i * 4 >> 2];
    var query = GL.queries[id];
    if (!query) continue;
    GLctx.deleteQuery(query);
    GL.queries[id] = null;
  }
};
var _emscripten_glDeleteQueries = _glDeleteQueries;
var _glDeleteQueriesEXT = function _glDeleteQueriesEXT(n, ids) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[ids + i * 4 >> 2];
    var query = GL.queries[id];
    if (!query) continue;
    GLctx.disjointTimerQueryExt["deleteQueryEXT"](query);
    GL.queries[id] = null;
  }
};
var _emscripten_glDeleteQueriesEXT = _glDeleteQueriesEXT;
var _glDeleteRenderbuffers = function _glDeleteRenderbuffers(n, renderbuffers) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[renderbuffers + i * 4 >> 2];
    var renderbuffer = GL.renderbuffers[id];
    if (!renderbuffer) continue;
    GLctx.deleteRenderbuffer(renderbuffer);
    renderbuffer.name = 0;
    GL.renderbuffers[id] = null;
  }
};
var _emscripten_glDeleteRenderbuffers = _glDeleteRenderbuffers;
var _glDeleteSamplers = function _glDeleteSamplers(n, samplers) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[samplers + i * 4 >> 2];
    var sampler = GL.samplers[id];
    if (!sampler) continue;
    GLctx.deleteSampler(sampler);
    sampler.name = 0;
    GL.samplers[id] = null;
  }
};
var _emscripten_glDeleteSamplers = _glDeleteSamplers;
var _glDeleteShader = function _glDeleteShader(id) {
  if (!id) return;
  var shader = GL.shaders[id];
  if (!shader) {
    GL.recordError(1281);
    return;
  }
  GLctx.deleteShader(shader);
  GL.shaders[id] = null;
};
var _emscripten_glDeleteShader = _glDeleteShader;
var _glDeleteSync = function _glDeleteSync(id) {
  if (!id) return;
  var sync = GL.syncs[id];
  if (!sync) {
    GL.recordError(1281);
    return;
  }
  GLctx.deleteSync(sync);
  sync.name = 0;
  GL.syncs[id] = null;
};
var _emscripten_glDeleteSync = _glDeleteSync;
var _glDeleteTextures = function _glDeleteTextures(n, textures) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[textures + i * 4 >> 2];
    var texture = GL.textures[id];
    if (!texture) continue;
    GLctx.deleteTexture(texture);
    texture.name = 0;
    GL.textures[id] = null;
  }
};
var _emscripten_glDeleteTextures = _glDeleteTextures;
var _glDeleteTransformFeedbacks = function _glDeleteTransformFeedbacks(n, ids) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[ids + i * 4 >> 2];
    var transformFeedback = GL.transformFeedbacks[id];
    if (!transformFeedback) continue;
    GLctx.deleteTransformFeedback(transformFeedback);
    transformFeedback.name = 0;
    GL.transformFeedbacks[id] = null;
  }
};
var _emscripten_glDeleteTransformFeedbacks = _glDeleteTransformFeedbacks;
var _glDeleteVertexArrays = function _glDeleteVertexArrays(n, vaos) {
  for (var i = 0; i < n; i++) {
    var id = HEAP32[vaos + i * 4 >> 2];
    GLctx.deleteVertexArray(GL.vaos[id]);
    GL.vaos[id] = null;
  }
};
var _emscripten_glDeleteVertexArrays = _glDeleteVertexArrays;
var _glDeleteVertexArraysOES = _glDeleteVertexArrays;
var _emscripten_glDeleteVertexArraysOES = _glDeleteVertexArraysOES;
var _glDepthFunc = function _glDepthFunc(x0) {
  return GLctx.depthFunc(x0);
};
var _emscripten_glDepthFunc = _glDepthFunc;
var _glDepthMask = function _glDepthMask(flag) {
  GLctx.depthMask(!!flag);
};
var _emscripten_glDepthMask = _glDepthMask;
var _glDepthRangef = function _glDepthRangef(x0, x1) {
  return GLctx.depthRange(x0, x1);
};
var _emscripten_glDepthRangef = _glDepthRangef;
var _glDetachShader = function _glDetachShader(program, shader) {
  GLctx.detachShader(GL.programs[program], GL.shaders[shader]);
};
var _emscripten_glDetachShader = _glDetachShader;
var _glDisable = function _glDisable(x0) {
  return GLctx.disable(x0);
};
var _emscripten_glDisable = _glDisable;
var _glDisableVertexAttribArray = function _glDisableVertexAttribArray(index) {
  GLctx.disableVertexAttribArray(index);
};
var _emscripten_glDisableVertexAttribArray = _glDisableVertexAttribArray;
var _glDrawArrays = function _glDrawArrays(mode, first, count) {
  GLctx.drawArrays(mode, first, count);
};
var _emscripten_glDrawArrays = _glDrawArrays;
var _glDrawArraysInstanced = function _glDrawArraysInstanced(mode, first, count, primcount) {
  GLctx.drawArraysInstanced(mode, first, count, primcount);
};
var _emscripten_glDrawArraysInstanced = _glDrawArraysInstanced;
var _glDrawArraysInstancedANGLE = _glDrawArraysInstanced;
var _emscripten_glDrawArraysInstancedANGLE = _glDrawArraysInstancedANGLE;
var _glDrawArraysInstancedARB = _glDrawArraysInstanced;
var _emscripten_glDrawArraysInstancedARB = _glDrawArraysInstancedARB;
var _glDrawArraysInstancedEXT = _glDrawArraysInstanced;
var _emscripten_glDrawArraysInstancedEXT = _glDrawArraysInstancedEXT;
var _glDrawArraysInstancedNV = _glDrawArraysInstanced;
var _emscripten_glDrawArraysInstancedNV = _glDrawArraysInstancedNV;
var tempFixedLengthArray = [];
var _glDrawBuffers = function _glDrawBuffers(n, bufs) {
  var bufArray = tempFixedLengthArray[n];
  for (var i = 0; i < n; i++) {
    bufArray[i] = HEAP32[bufs + i * 4 >> 2];
  }
  GLctx.drawBuffers(bufArray);
};
var _emscripten_glDrawBuffers = _glDrawBuffers;
var _glDrawBuffersEXT = _glDrawBuffers;
var _emscripten_glDrawBuffersEXT = _glDrawBuffersEXT;
var _glDrawBuffersWEBGL = _glDrawBuffers;
var _emscripten_glDrawBuffersWEBGL = _glDrawBuffersWEBGL;
var _glDrawElements = function _glDrawElements(mode, count, type, indices) {
  GLctx.drawElements(mode, count, type, indices);
};
var _emscripten_glDrawElements = _glDrawElements;
var _glDrawElementsInstanced = function _glDrawElementsInstanced(mode, count, type, indices, primcount) {
  GLctx.drawElementsInstanced(mode, count, type, indices, primcount);
};
var _emscripten_glDrawElementsInstanced = _glDrawElementsInstanced;
var _glDrawElementsInstancedANGLE = _glDrawElementsInstanced;
var _emscripten_glDrawElementsInstancedANGLE = _glDrawElementsInstancedANGLE;
var _glDrawElementsInstancedARB = _glDrawElementsInstanced;
var _emscripten_glDrawElementsInstancedARB = _glDrawElementsInstancedARB;
var _glDrawElementsInstancedEXT = _glDrawElementsInstanced;
var _emscripten_glDrawElementsInstancedEXT = _glDrawElementsInstancedEXT;
var _glDrawElementsInstancedNV = _glDrawElementsInstanced;
var _emscripten_glDrawElementsInstancedNV = _glDrawElementsInstancedNV;
var _glDrawRangeElements = function _glDrawRangeElements(mode, start, end, count, type, indices) {
  _glDrawElements(mode, count, type, indices);
};
var _emscripten_glDrawRangeElements = _glDrawRangeElements;
var _glEnable = function _glEnable(x0) {
  return GLctx.enable(x0);
};
var _emscripten_glEnable = _glEnable;
var _glEnableVertexAttribArray = function _glEnableVertexAttribArray(index) {
  GLctx.enableVertexAttribArray(index);
};
var _emscripten_glEnableVertexAttribArray = _glEnableVertexAttribArray;
var _glEndQuery = function _glEndQuery(x0) {
  return GLctx.endQuery(x0);
};
var _emscripten_glEndQuery = _glEndQuery;
var _glEndQueryEXT = function _glEndQueryEXT(target) {
  GLctx.disjointTimerQueryExt["endQueryEXT"](target);
};
var _emscripten_glEndQueryEXT = _glEndQueryEXT;
var _glEndTransformFeedback = function _glEndTransformFeedback() {
  return GLctx.endTransformFeedback();
};
var _emscripten_glEndTransformFeedback = _glEndTransformFeedback;
var _glFenceSync = function _glFenceSync(condition, flags) {
  var sync = GLctx.fenceSync(condition, flags);
  if (sync) {
    var id = GL.getNewId(GL.syncs);
    sync.name = id;
    GL.syncs[id] = sync;
    return id;
  }
  return 0;
};
var _emscripten_glFenceSync = _glFenceSync;
var _glFinish = function _glFinish() {
  return GLctx.finish();
};
var _emscripten_glFinish = _glFinish;
var _glFlush = function _glFlush() {
  return GLctx.flush();
};
var _emscripten_glFlush = _glFlush;
var _glFramebufferRenderbuffer = function _glFramebufferRenderbuffer(target, attachment, renderbuffertarget, renderbuffer) {
  GLctx.framebufferRenderbuffer(target, attachment, renderbuffertarget, GL.renderbuffers[renderbuffer]);
};
var _emscripten_glFramebufferRenderbuffer = _glFramebufferRenderbuffer;
var _glFramebufferTexture2D = function _glFramebufferTexture2D(target, attachment, textarget, texture, level) {
  GLctx.framebufferTexture2D(target, attachment, textarget, GL.textures[texture], level);
};
var _emscripten_glFramebufferTexture2D = _glFramebufferTexture2D;
var _glFramebufferTextureLayer = function _glFramebufferTextureLayer(target, attachment, texture, level, layer) {
  GLctx.framebufferTextureLayer(target, attachment, GL.textures[texture], level, layer);
};
var _emscripten_glFramebufferTextureLayer = _glFramebufferTextureLayer;
var _glFrontFace = function _glFrontFace(x0) {
  return GLctx.frontFace(x0);
};
var _emscripten_glFrontFace = _glFrontFace;
var _glGenBuffers = function _glGenBuffers(n, buffers) {
  GL.genObject(n, buffers, "createBuffer", GL.buffers);
};
var _emscripten_glGenBuffers = _glGenBuffers;
var _glGenFramebuffers = function _glGenFramebuffers(n, ids) {
  GL.genObject(n, ids, "createFramebuffer", GL.framebuffers);
};
var _emscripten_glGenFramebuffers = _glGenFramebuffers;
var _glGenQueries = function _glGenQueries(n, ids) {
  GL.genObject(n, ids, "createQuery", GL.queries);
};
var _emscripten_glGenQueries = _glGenQueries;
var _glGenQueriesEXT = function _glGenQueriesEXT(n, ids) {
  for (var i = 0; i < n; i++) {
    var query = GLctx.disjointTimerQueryExt["createQueryEXT"]();
    if (!query) {
      GL.recordError(1282);
      while (i < n) HEAP32[ids + i++ * 4 >> 2] = 0;
      return;
    }
    var id = GL.getNewId(GL.queries);
    query.name = id;
    GL.queries[id] = query;
    HEAP32[ids + i * 4 >> 2] = id;
  }
};
var _emscripten_glGenQueriesEXT = _glGenQueriesEXT;
var _glGenRenderbuffers = function _glGenRenderbuffers(n, renderbuffers) {
  GL.genObject(n, renderbuffers, "createRenderbuffer", GL.renderbuffers);
};
var _emscripten_glGenRenderbuffers = _glGenRenderbuffers;
var _glGenSamplers = function _glGenSamplers(n, samplers) {
  GL.genObject(n, samplers, "createSampler", GL.samplers);
};
var _emscripten_glGenSamplers = _glGenSamplers;
var _glGenTextures = function _glGenTextures(n, textures) {
  GL.genObject(n, textures, "createTexture", GL.textures);
};
var _emscripten_glGenTextures = _glGenTextures;
var _glGenTransformFeedbacks = function _glGenTransformFeedbacks(n, ids) {
  GL.genObject(n, ids, "createTransformFeedback", GL.transformFeedbacks);
};
var _emscripten_glGenTransformFeedbacks = _glGenTransformFeedbacks;
var _glGenVertexArrays = function _glGenVertexArrays(n, arrays) {
  GL.genObject(n, arrays, "createVertexArray", GL.vaos);
};
var _emscripten_glGenVertexArrays = _glGenVertexArrays;
var _glGenVertexArraysOES = _glGenVertexArrays;
var _emscripten_glGenVertexArraysOES = _glGenVertexArraysOES;
var _glGenerateMipmap = function _glGenerateMipmap(x0) {
  return GLctx.generateMipmap(x0);
};
var _emscripten_glGenerateMipmap = _glGenerateMipmap;
var __glGetActiveAttribOrUniform = function __glGetActiveAttribOrUniform(funcName, program, index, bufSize, length, size, type, name) {
  program = GL.programs[program];
  var info = GLctx[funcName](program, index);
  if (info) {
    var numBytesWrittenExclNull = name && stringToUTF8(info.name, name, bufSize);
    if (length) HEAP32[length >> 2] = numBytesWrittenExclNull;
    if (size) HEAP32[size >> 2] = info.size;
    if (type) HEAP32[type >> 2] = info.type;
  }
};
var _glGetActiveAttrib = function _glGetActiveAttrib(program, index, bufSize, length, size, type, name) {
  __glGetActiveAttribOrUniform("getActiveAttrib", program, index, bufSize, length, size, type, name);
};
var _emscripten_glGetActiveAttrib = _glGetActiveAttrib;
var _glGetActiveUniform = function _glGetActiveUniform(program, index, bufSize, length, size, type, name) {
  __glGetActiveAttribOrUniform("getActiveUniform", program, index, bufSize, length, size, type, name);
};
var _emscripten_glGetActiveUniform = _glGetActiveUniform;
var _glGetActiveUniformBlockName = function _glGetActiveUniformBlockName(program, uniformBlockIndex, bufSize, length, uniformBlockName) {
  program = GL.programs[program];
  var result = GLctx.getActiveUniformBlockName(program, uniformBlockIndex);
  if (!result) return;
  if (uniformBlockName && bufSize > 0) {
    var numBytesWrittenExclNull = stringToUTF8(result, uniformBlockName, bufSize);
    if (length) HEAP32[length >> 2] = numBytesWrittenExclNull;
  } else {
    if (length) HEAP32[length >> 2] = 0;
  }
};
var _emscripten_glGetActiveUniformBlockName = _glGetActiveUniformBlockName;
var _glGetActiveUniformBlockiv = function _glGetActiveUniformBlockiv(program, uniformBlockIndex, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  program = GL.programs[program];
  if (pname == 35393) {
    var name = GLctx.getActiveUniformBlockName(program, uniformBlockIndex);
    HEAP32[params >> 2] = name.length + 1;
    return;
  }
  var result = GLctx.getActiveUniformBlockParameter(program, uniformBlockIndex, pname);
  if (result === null) return;
  if (pname == 35395) {
    for (var i = 0; i < result.length; i++) {
      HEAP32[params + i * 4 >> 2] = result[i];
    }
  } else {
    HEAP32[params >> 2] = result;
  }
};
var _emscripten_glGetActiveUniformBlockiv = _glGetActiveUniformBlockiv;
var _glGetActiveUniformsiv = function _glGetActiveUniformsiv(program, uniformCount, uniformIndices, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  if (uniformCount > 0 && uniformIndices == 0) {
    GL.recordError(1281);
    return;
  }
  program = GL.programs[program];
  var ids = [];
  for (var i = 0; i < uniformCount; i++) {
    ids.push(HEAP32[uniformIndices + i * 4 >> 2]);
  }
  var result = GLctx.getActiveUniforms(program, ids, pname);
  if (!result) return;
  var len = result.length;
  for (var i = 0; i < len; i++) {
    HEAP32[params + i * 4 >> 2] = result[i];
  }
};
var _emscripten_glGetActiveUniformsiv = _glGetActiveUniformsiv;
var _glGetAttachedShaders = function _glGetAttachedShaders(program, maxCount, count, shaders) {
  var result = GLctx.getAttachedShaders(GL.programs[program]);
  var len = result.length;
  if (len > maxCount) {
    len = maxCount;
  }
  HEAP32[count >> 2] = len;
  for (var i = 0; i < len; ++i) {
    var id = GL.shaders.indexOf(result[i]);
    HEAP32[shaders + i * 4 >> 2] = id;
  }
};
var _emscripten_glGetAttachedShaders = _glGetAttachedShaders;
var _glGetAttribLocation = function _glGetAttribLocation(program, name) {
  return GLctx.getAttribLocation(GL.programs[program], UTF8ToString(name));
};
var _emscripten_glGetAttribLocation = _glGetAttribLocation;
var writeI53ToI64 = function writeI53ToI64(ptr, num) {
  HEAPU32[ptr >> 2] = num;
  var lower = HEAPU32[ptr >> 2];
  HEAPU32[ptr + 4 >> 2] = (num - lower) / 4294967296;
};
var getEmscriptenSupportedExtensions = function getEmscriptenSupportedExtensions(ctx) {
  var supportedExtensions = ["ANGLE_instanced_arrays", "EXT_blend_minmax", "EXT_disjoint_timer_query", "EXT_frag_depth", "EXT_shader_texture_lod", "EXT_sRGB", "OES_element_index_uint", "OES_fbo_render_mipmap", "OES_standard_derivatives", "OES_texture_float", "OES_texture_half_float", "OES_texture_half_float_linear", "OES_vertex_array_object", "WEBGL_color_buffer_float", "WEBGL_depth_texture", "WEBGL_draw_buffers", "EXT_color_buffer_float", "EXT_conservative_depth", "EXT_disjoint_timer_query_webgl2", "EXT_texture_norm16", "NV_shader_noperspective_interpolation", "WEBGL_clip_cull_distance", "EXT_color_buffer_half_float", "EXT_depth_clamp", "EXT_float_blend", "EXT_texture_compression_bptc", "EXT_texture_compression_rgtc", "EXT_texture_filter_anisotropic", "KHR_parallel_shader_compile", "OES_texture_float_linear", "WEBGL_blend_func_extended", "WEBGL_compressed_texture_astc", "WEBGL_compressed_texture_etc", "WEBGL_compressed_texture_etc1", "WEBGL_compressed_texture_s3tc", "WEBGL_compressed_texture_s3tc_srgb", "WEBGL_debug_renderer_info", "WEBGL_debug_shaders", "WEBGL_lose_context", "WEBGL_multi_draw"];
  return (ctx.getSupportedExtensions() || []).filter(function (ext) {
    return supportedExtensions.includes(ext);
  });
};
var webglGetExtensions = function $webglGetExtensions() {
  var exts = getEmscriptenSupportedExtensions(GLctx);
  exts = exts.concat(exts.map(function (e) {
    return "GL_" + e;
  }));
  return exts;
};
var emscriptenWebGLGet = function emscriptenWebGLGet(name_, p, type) {
  if (!p) {
    GL.recordError(1281);
    return;
  }
  var ret = undefined;
  switch (name_) {
    case 36346:
      ret = 1;
      break;
    case 36344:
      if (type != 0 && type != 1) {
        GL.recordError(1280);
      }
      return;
    case 34814:
    case 36345:
      ret = 0;
      break;
    case 34466:
      var formats = GLctx.getParameter(34467);
      ret = formats ? formats.length : 0;
      break;
    case 33309:
      if (GL.currentContext.version < 2) {
        GL.recordError(1282);
        return;
      }
      ret = webglGetExtensions().length;
      break;
    case 33307:
    case 33308:
      if (GL.currentContext.version < 2) {
        GL.recordError(1280);
        return;
      }
      ret = name_ == 33307 ? 3 : 0;
      break;
  }
  if (ret === undefined) {
    var result = GLctx.getParameter(name_);
    switch (_typeof(result)) {
      case "number":
        ret = result;
        break;
      case "boolean":
        ret = result ? 1 : 0;
        break;
      case "string":
        GL.recordError(1280);
        return;
      case "object":
        if (result === null) {
          switch (name_) {
            case 34964:
            case 35725:
            case 34965:
            case 36006:
            case 36007:
            case 32873:
            case 34229:
            case 36662:
            case 36663:
            case 35053:
            case 35055:
            case 36010:
            case 35097:
            case 35869:
            case 32874:
            case 36389:
            case 35983:
            case 35368:
            case 34068:
              {
                ret = 0;
                break;
              }
            default:
              {
                GL.recordError(1280);
                return;
              }
          }
        } else if (result instanceof Float32Array || result instanceof Uint32Array || result instanceof Int32Array || result instanceof Array) {
          for (var i = 0; i < result.length; ++i) {
            switch (type) {
              case 0:
                HEAP32[p + i * 4 >> 2] = result[i];
                break;
              case 2:
                HEAPF32[p + i * 4 >> 2] = result[i];
                break;
              case 4:
                HEAP8[p + i] = result[i] ? 1 : 0;
                break;
            }
          }
          return;
        } else {
          try {
            ret = result.name | 0;
          } catch (e) {
            GL.recordError(1280);
            err("GL_INVALID_ENUM in glGet".concat(type, "v: Unknown object returned from WebGL getParameter(").concat(name_, ")! (error: ").concat(e, ")"));
            return;
          }
        }
        break;
      default:
        GL.recordError(1280);
        err("GL_INVALID_ENUM in glGet".concat(type, "v: Native code calling glGet").concat(type, "v(").concat(name_, ") and it returns ").concat(result, " of type ").concat(_typeof(result), "!"));
        return;
    }
  }
  switch (type) {
    case 1:
      writeI53ToI64(p, ret);
      break;
    case 0:
      HEAP32[p >> 2] = ret;
      break;
    case 2:
      HEAPF32[p >> 2] = ret;
      break;
    case 4:
      HEAP8[p] = ret ? 1 : 0;
      break;
  }
};
var _glGetBooleanv = function _glGetBooleanv(name_, p) {
  return emscriptenWebGLGet(name_, p, 4);
};
var _emscripten_glGetBooleanv = _glGetBooleanv;
var _glGetBufferParameteri64v = function _glGetBufferParameteri64v(target, value, data) {
  if (!data) {
    GL.recordError(1281);
    return;
  }
  writeI53ToI64(data, GLctx.getBufferParameter(target, value));
};
var _emscripten_glGetBufferParameteri64v = _glGetBufferParameteri64v;
var _glGetBufferParameteriv = function _glGetBufferParameteriv(target, value, data) {
  if (!data) {
    GL.recordError(1281);
    return;
  }
  HEAP32[data >> 2] = GLctx.getBufferParameter(target, value);
};
var _emscripten_glGetBufferParameteriv = _glGetBufferParameteriv;
var _glGetError = function _glGetError() {
  var error = GLctx.getError() || GL.lastError;
  GL.lastError = 0;
  return error;
};
var _emscripten_glGetError = _glGetError;
var _glGetFloatv = function _glGetFloatv(name_, p) {
  return emscriptenWebGLGet(name_, p, 2);
};
var _emscripten_glGetFloatv = _glGetFloatv;
var _glGetFragDataLocation = function _glGetFragDataLocation(program, name) {
  return GLctx.getFragDataLocation(GL.programs[program], UTF8ToString(name));
};
var _emscripten_glGetFragDataLocation = _glGetFragDataLocation;
var _glGetFramebufferAttachmentParameteriv = function _glGetFramebufferAttachmentParameteriv(target, attachment, pname, params) {
  var result = GLctx.getFramebufferAttachmentParameter(target, attachment, pname);
  if (result instanceof WebGLRenderbuffer || result instanceof WebGLTexture) {
    result = result.name | 0;
  }
  HEAP32[params >> 2] = result;
};
var _emscripten_glGetFramebufferAttachmentParameteriv = _glGetFramebufferAttachmentParameteriv;
var emscriptenWebGLGetIndexed = function emscriptenWebGLGetIndexed(target, index, data, type) {
  if (!data) {
    GL.recordError(1281);
    return;
  }
  var result = GLctx.getIndexedParameter(target, index);
  var ret;
  switch (_typeof(result)) {
    case "boolean":
      ret = result ? 1 : 0;
      break;
    case "number":
      ret = result;
      break;
    case "object":
      if (result === null) {
        switch (target) {
          case 35983:
          case 35368:
            ret = 0;
            break;
          default:
            {
              GL.recordError(1280);
              return;
            }
        }
      } else if (result instanceof WebGLBuffer) {
        ret = result.name | 0;
      } else {
        GL.recordError(1280);
        return;
      }
      break;
    default:
      GL.recordError(1280);
      return;
  }
  switch (type) {
    case 1:
      writeI53ToI64(data, ret);
      break;
    case 0:
      HEAP32[data >> 2] = ret;
      break;
    case 2:
      HEAPF32[data >> 2] = ret;
      break;
    case 4:
      HEAP8[data] = ret ? 1 : 0;
      break;
    default:
      throw "internal emscriptenWebGLGetIndexed() error, bad type: " + type;
  }
};
var _glGetInteger64i_v = function _glGetInteger64i_v(target, index, data) {
  return emscriptenWebGLGetIndexed(target, index, data, 1);
};
var _emscripten_glGetInteger64i_v = _glGetInteger64i_v;
var _glGetInteger64v = function _glGetInteger64v(name_, p) {
  emscriptenWebGLGet(name_, p, 1);
};
var _emscripten_glGetInteger64v = _glGetInteger64v;
var _glGetIntegeri_v = function _glGetIntegeri_v(target, index, data) {
  return emscriptenWebGLGetIndexed(target, index, data, 0);
};
var _emscripten_glGetIntegeri_v = _glGetIntegeri_v;
var _glGetIntegerv = function _glGetIntegerv(name_, p) {
  return emscriptenWebGLGet(name_, p, 0);
};
var _emscripten_glGetIntegerv = _glGetIntegerv;
var _glGetInternalformativ = function _glGetInternalformativ(target, internalformat, pname, bufSize, params) {
  if (bufSize < 0) {
    GL.recordError(1281);
    return;
  }
  if (!params) {
    GL.recordError(1281);
    return;
  }
  var ret = GLctx.getInternalformatParameter(target, internalformat, pname);
  if (ret === null) return;
  for (var i = 0; i < ret.length && i < bufSize; ++i) {
    HEAP32[params + i * 4 >> 2] = ret[i];
  }
};
var _emscripten_glGetInternalformativ = _glGetInternalformativ;
var _glGetProgramBinary = function _glGetProgramBinary(program, bufSize, length, binaryFormat, binary) {
  GL.recordError(1282);
};
var _emscripten_glGetProgramBinary = _glGetProgramBinary;
var _glGetProgramInfoLog = function _glGetProgramInfoLog(program, maxLength, length, infoLog) {
  var log = GLctx.getProgramInfoLog(GL.programs[program]);
  if (log === null) log = "(unknown error)";
  var numBytesWrittenExclNull = maxLength > 0 && infoLog ? stringToUTF8(log, infoLog, maxLength) : 0;
  if (length) HEAP32[length >> 2] = numBytesWrittenExclNull;
};
var _emscripten_glGetProgramInfoLog = _glGetProgramInfoLog;
var _glGetProgramiv = function _glGetProgramiv(program, pname, p) {
  if (!p) {
    GL.recordError(1281);
    return;
  }
  if (program >= GL.counter) {
    GL.recordError(1281);
    return;
  }
  program = GL.programs[program];
  if (pname == 35716) {
    var log = GLctx.getProgramInfoLog(program);
    if (log === null) log = "(unknown error)";
    HEAP32[p >> 2] = log.length + 1;
  } else if (pname == 35719) {
    if (!program.maxUniformLength) {
      for (var i = 0; i < GLctx.getProgramParameter(program, 35718); ++i) {
        program.maxUniformLength = Math.max(program.maxUniformLength, GLctx.getActiveUniform(program, i).name.length + 1);
      }
    }
    HEAP32[p >> 2] = program.maxUniformLength;
  } else if (pname == 35722) {
    if (!program.maxAttributeLength) {
      for (var i = 0; i < GLctx.getProgramParameter(program, 35721); ++i) {
        program.maxAttributeLength = Math.max(program.maxAttributeLength, GLctx.getActiveAttrib(program, i).name.length + 1);
      }
    }
    HEAP32[p >> 2] = program.maxAttributeLength;
  } else if (pname == 35381) {
    if (!program.maxUniformBlockNameLength) {
      for (var i = 0; i < GLctx.getProgramParameter(program, 35382); ++i) {
        program.maxUniformBlockNameLength = Math.max(program.maxUniformBlockNameLength, GLctx.getActiveUniformBlockName(program, i).length + 1);
      }
    }
    HEAP32[p >> 2] = program.maxUniformBlockNameLength;
  } else {
    HEAP32[p >> 2] = GLctx.getProgramParameter(program, pname);
  }
};
var _emscripten_glGetProgramiv = _glGetProgramiv;
var _glGetQueryObjecti64vEXT = function _glGetQueryObjecti64vEXT(id, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  var query = GL.queries[id];
  var param;
  if (GL.currentContext.version < 2) {
    param = GLctx.disjointTimerQueryExt["getQueryObjectEXT"](query, pname);
  } else {
    param = GLctx.getQueryParameter(query, pname);
  }
  var ret;
  if (typeof param == "boolean") {
    ret = param ? 1 : 0;
  } else {
    ret = param;
  }
  writeI53ToI64(params, ret);
};
var _emscripten_glGetQueryObjecti64vEXT = _glGetQueryObjecti64vEXT;
var _glGetQueryObjectivEXT = function _glGetQueryObjectivEXT(id, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  var query = GL.queries[id];
  var param = GLctx.disjointTimerQueryExt["getQueryObjectEXT"](query, pname);
  var ret;
  if (typeof param == "boolean") {
    ret = param ? 1 : 0;
  } else {
    ret = param;
  }
  HEAP32[params >> 2] = ret;
};
var _emscripten_glGetQueryObjectivEXT = _glGetQueryObjectivEXT;
var _glGetQueryObjectui64vEXT = _glGetQueryObjecti64vEXT;
var _emscripten_glGetQueryObjectui64vEXT = _glGetQueryObjectui64vEXT;
var _glGetQueryObjectuiv = function _glGetQueryObjectuiv(id, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  var query = GL.queries[id];
  var param = GLctx.getQueryParameter(query, pname);
  var ret;
  if (typeof param == "boolean") {
    ret = param ? 1 : 0;
  } else {
    ret = param;
  }
  HEAP32[params >> 2] = ret;
};
var _emscripten_glGetQueryObjectuiv = _glGetQueryObjectuiv;
var _glGetQueryObjectuivEXT = _glGetQueryObjectivEXT;
var _emscripten_glGetQueryObjectuivEXT = _glGetQueryObjectuivEXT;
var _glGetQueryiv = function _glGetQueryiv(target, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  HEAP32[params >> 2] = GLctx.getQuery(target, pname);
};
var _emscripten_glGetQueryiv = _glGetQueryiv;
var _glGetQueryivEXT = function _glGetQueryivEXT(target, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  HEAP32[params >> 2] = GLctx.disjointTimerQueryExt["getQueryEXT"](target, pname);
};
var _emscripten_glGetQueryivEXT = _glGetQueryivEXT;
var _glGetRenderbufferParameteriv = function _glGetRenderbufferParameteriv(target, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  HEAP32[params >> 2] = GLctx.getRenderbufferParameter(target, pname);
};
var _emscripten_glGetRenderbufferParameteriv = _glGetRenderbufferParameteriv;
var _glGetSamplerParameterfv = function _glGetSamplerParameterfv(sampler, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  HEAPF32[params >> 2] = GLctx.getSamplerParameter(GL.samplers[sampler], pname);
};
var _emscripten_glGetSamplerParameterfv = _glGetSamplerParameterfv;
var _glGetSamplerParameteriv = function _glGetSamplerParameteriv(sampler, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  HEAP32[params >> 2] = GLctx.getSamplerParameter(GL.samplers[sampler], pname);
};
var _emscripten_glGetSamplerParameteriv = _glGetSamplerParameteriv;
var _glGetShaderInfoLog = function _glGetShaderInfoLog(shader, maxLength, length, infoLog) {
  var log = GLctx.getShaderInfoLog(GL.shaders[shader]);
  if (log === null) log = "(unknown error)";
  var numBytesWrittenExclNull = maxLength > 0 && infoLog ? stringToUTF8(log, infoLog, maxLength) : 0;
  if (length) HEAP32[length >> 2] = numBytesWrittenExclNull;
};
var _emscripten_glGetShaderInfoLog = _glGetShaderInfoLog;
var _glGetShaderPrecisionFormat = function _glGetShaderPrecisionFormat(shaderType, precisionType, range, precision) {
  var result = GLctx.getShaderPrecisionFormat(shaderType, precisionType);
  HEAP32[range >> 2] = result.rangeMin;
  HEAP32[range + 4 >> 2] = result.rangeMax;
  HEAP32[precision >> 2] = result.precision;
};
var _emscripten_glGetShaderPrecisionFormat = _glGetShaderPrecisionFormat;
var _glGetShaderSource = function _glGetShaderSource(shader, bufSize, length, source) {
  var result = GLctx.getShaderSource(GL.shaders[shader]);
  if (!result) return;
  var numBytesWrittenExclNull = bufSize > 0 && source ? stringToUTF8(result, source, bufSize) : 0;
  if (length) HEAP32[length >> 2] = numBytesWrittenExclNull;
};
var _emscripten_glGetShaderSource = _glGetShaderSource;
var _glGetShaderiv = function _glGetShaderiv(shader, pname, p) {
  if (!p) {
    GL.recordError(1281);
    return;
  }
  if (pname == 35716) {
    var log = GLctx.getShaderInfoLog(GL.shaders[shader]);
    if (log === null) log = "(unknown error)";
    var logLength = log ? log.length + 1 : 0;
    HEAP32[p >> 2] = logLength;
  } else if (pname == 35720) {
    var source = GLctx.getShaderSource(GL.shaders[shader]);
    var sourceLength = source ? source.length + 1 : 0;
    HEAP32[p >> 2] = sourceLength;
  } else {
    HEAP32[p >> 2] = GLctx.getShaderParameter(GL.shaders[shader], pname);
  }
};
var _emscripten_glGetShaderiv = _glGetShaderiv;
var stringToNewUTF8 = function stringToNewUTF8(str) {
  var size = lengthBytesUTF8(str) + 1;
  var ret = _malloc(size);
  if (ret) stringToUTF8(str, ret, size);
  return ret;
};
var _glGetString = function _glGetString(name_) {
  var ret = GL.stringCache[name_];
  if (!ret) {
    switch (name_) {
      case 7939:
        ret = stringToNewUTF8(webglGetExtensions().join(" "));
        break;
      case 7936:
      case 7937:
      case 37445:
      case 37446:
        var s = GLctx.getParameter(name_);
        if (!s) {
          GL.recordError(1280);
        }
        ret = s ? stringToNewUTF8(s) : 0;
        break;
      case 7938:
        var glVersion = GLctx.getParameter(7938);
        if (GL.currentContext.version >= 2) glVersion = "OpenGL ES 3.0 (".concat(glVersion, ")");else {
          glVersion = "OpenGL ES 2.0 (".concat(glVersion, ")");
        }
        ret = stringToNewUTF8(glVersion);
        break;
      case 35724:
        var glslVersion = GLctx.getParameter(35724);
        var ver_re = /^WebGL GLSL ES ([0-9]\.[0-9][0-9]?)(?:$| .*)/;
        var ver_num = glslVersion.match(ver_re);
        if (ver_num !== null) {
          if (ver_num[1].length == 3) ver_num[1] = ver_num[1] + "0";
          glslVersion = "OpenGL ES GLSL ES ".concat(ver_num[1], " (").concat(glslVersion, ")");
        }
        ret = stringToNewUTF8(glslVersion);
        break;
      default:
        GL.recordError(1280);
    }
    GL.stringCache[name_] = ret;
  }
  return ret;
};
var _emscripten_glGetString = _glGetString;
var _glGetStringi = function _glGetStringi(name, index) {
  if (GL.currentContext.version < 2) {
    GL.recordError(1282);
    return 0;
  }
  var stringiCache = GL.stringiCache[name];
  if (stringiCache) {
    if (index < 0 || index >= stringiCache.length) {
      GL.recordError(1281);
      return 0;
    }
    return stringiCache[index];
  }
  switch (name) {
    case 7939:
      var exts = webglGetExtensions().map(stringToNewUTF8);
      stringiCache = GL.stringiCache[name] = exts;
      if (index < 0 || index >= stringiCache.length) {
        GL.recordError(1281);
        return 0;
      }
      return stringiCache[index];
    default:
      GL.recordError(1280);
      return 0;
  }
};
var _emscripten_glGetStringi = _glGetStringi;
var _glGetSynciv = function _glGetSynciv(sync, pname, bufSize, length, values) {
  if (bufSize < 0) {
    GL.recordError(1281);
    return;
  }
  if (!values) {
    GL.recordError(1281);
    return;
  }
  var ret = GLctx.getSyncParameter(GL.syncs[sync], pname);
  if (ret !== null) {
    HEAP32[values >> 2] = ret;
    if (length) HEAP32[length >> 2] = 1;
  }
};
var _emscripten_glGetSynciv = _glGetSynciv;
var _glGetTexParameterfv = function _glGetTexParameterfv(target, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  HEAPF32[params >> 2] = GLctx.getTexParameter(target, pname);
};
var _emscripten_glGetTexParameterfv = _glGetTexParameterfv;
var _glGetTexParameteriv = function _glGetTexParameteriv(target, pname, params) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  HEAP32[params >> 2] = GLctx.getTexParameter(target, pname);
};
var _emscripten_glGetTexParameteriv = _glGetTexParameteriv;
var _glGetTransformFeedbackVarying = function _glGetTransformFeedbackVarying(program, index, bufSize, length, size, type, name) {
  program = GL.programs[program];
  var info = GLctx.getTransformFeedbackVarying(program, index);
  if (!info) return;
  if (name && bufSize > 0) {
    var numBytesWrittenExclNull = stringToUTF8(info.name, name, bufSize);
    if (length) HEAP32[length >> 2] = numBytesWrittenExclNull;
  } else {
    if (length) HEAP32[length >> 2] = 0;
  }
  if (size) HEAP32[size >> 2] = info.size;
  if (type) HEAP32[type >> 2] = info.type;
};
var _emscripten_glGetTransformFeedbackVarying = _glGetTransformFeedbackVarying;
var _glGetUniformBlockIndex = function _glGetUniformBlockIndex(program, uniformBlockName) {
  return GLctx.getUniformBlockIndex(GL.programs[program], UTF8ToString(uniformBlockName));
};
var _emscripten_glGetUniformBlockIndex = _glGetUniformBlockIndex;
var _glGetUniformIndices = function _glGetUniformIndices(program, uniformCount, uniformNames, uniformIndices) {
  if (!uniformIndices) {
    GL.recordError(1281);
    return;
  }
  if (uniformCount > 0 && (uniformNames == 0 || uniformIndices == 0)) {
    GL.recordError(1281);
    return;
  }
  program = GL.programs[program];
  var names = [];
  for (var i = 0; i < uniformCount; i++) names.push(UTF8ToString(HEAP32[uniformNames + i * 4 >> 2]));
  var result = GLctx.getUniformIndices(program, names);
  if (!result) return;
  var len = result.length;
  for (var i = 0; i < len; i++) {
    HEAP32[uniformIndices + i * 4 >> 2] = result[i];
  }
};
var _emscripten_glGetUniformIndices = _glGetUniformIndices;
var webglGetLeftBracePos = function webglGetLeftBracePos(name) {
  return name.slice(-1) == "]" && name.lastIndexOf("[");
};
var webglPrepareUniformLocationsBeforeFirstUse = function webglPrepareUniformLocationsBeforeFirstUse(program) {
  var uniformLocsById = program.uniformLocsById,
    uniformSizeAndIdsByName = program.uniformSizeAndIdsByName,
    i,
    j;
  if (!uniformLocsById) {
    program.uniformLocsById = uniformLocsById = {};
    program.uniformArrayNamesById = {};
    for (i = 0; i < GLctx.getProgramParameter(program, 35718); ++i) {
      var u = GLctx.getActiveUniform(program, i);
      var nm = u.name;
      var sz = u.size;
      var lb = webglGetLeftBracePos(nm);
      var arrayName = lb > 0 ? nm.slice(0, lb) : nm;
      var id = program.uniformIdCounter;
      program.uniformIdCounter += sz;
      uniformSizeAndIdsByName[arrayName] = [sz, id];
      for (j = 0; j < sz; ++j) {
        uniformLocsById[id] = j;
        program.uniformArrayNamesById[id++] = arrayName;
      }
    }
  }
};
var _glGetUniformLocation = function _glGetUniformLocation(program, name) {
  name = UTF8ToString(name);
  if (program = GL.programs[program]) {
    webglPrepareUniformLocationsBeforeFirstUse(program);
    var uniformLocsById = program.uniformLocsById;
    var arrayIndex = 0;
    var uniformBaseName = name;
    var leftBrace = webglGetLeftBracePos(name);
    if (leftBrace > 0) {
      arrayIndex = jstoi_q(name.slice(leftBrace + 1)) >>> 0;
      uniformBaseName = name.slice(0, leftBrace);
    }
    var sizeAndId = program.uniformSizeAndIdsByName[uniformBaseName];
    if (sizeAndId && arrayIndex < sizeAndId[0]) {
      arrayIndex += sizeAndId[1];
      if (uniformLocsById[arrayIndex] = uniformLocsById[arrayIndex] || GLctx.getUniformLocation(program, name)) {
        return arrayIndex;
      }
    }
  } else {
    GL.recordError(1281);
  }
  return -1;
};
var _emscripten_glGetUniformLocation = _glGetUniformLocation;
var webglGetUniformLocation = function webglGetUniformLocation(location) {
  var p = GLctx.currentProgram;
  if (p) {
    var webglLoc = p.uniformLocsById[location];
    if (typeof webglLoc == "number") {
      p.uniformLocsById[location] = webglLoc = GLctx.getUniformLocation(p, p.uniformArrayNamesById[location] + (webglLoc > 0 ? "[".concat(webglLoc, "]") : ""));
    }
    return webglLoc;
  } else {
    GL.recordError(1282);
  }
};
var emscriptenWebGLGetUniform = function emscriptenWebGLGetUniform(program, location, params, type) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  program = GL.programs[program];
  webglPrepareUniformLocationsBeforeFirstUse(program);
  var data = GLctx.getUniform(program, webglGetUniformLocation(location));
  if (typeof data == "number" || typeof data == "boolean") {
    switch (type) {
      case 0:
        HEAP32[params >> 2] = data;
        break;
      case 2:
        HEAPF32[params >> 2] = data;
        break;
    }
  } else {
    for (var i = 0; i < data.length; i++) {
      switch (type) {
        case 0:
          HEAP32[params + i * 4 >> 2] = data[i];
          break;
        case 2:
          HEAPF32[params + i * 4 >> 2] = data[i];
          break;
      }
    }
  }
};
var _glGetUniformfv = function _glGetUniformfv(program, location, params) {
  emscriptenWebGLGetUniform(program, location, params, 2);
};
var _emscripten_glGetUniformfv = _glGetUniformfv;
var _glGetUniformiv = function _glGetUniformiv(program, location, params) {
  emscriptenWebGLGetUniform(program, location, params, 0);
};
var _emscripten_glGetUniformiv = _glGetUniformiv;
var _glGetUniformuiv = function _glGetUniformuiv(program, location, params) {
  return emscriptenWebGLGetUniform(program, location, params, 0);
};
var _emscripten_glGetUniformuiv = _glGetUniformuiv;
var emscriptenWebGLGetVertexAttrib = function emscriptenWebGLGetVertexAttrib(index, pname, params, type) {
  if (!params) {
    GL.recordError(1281);
    return;
  }
  var data = GLctx.getVertexAttrib(index, pname);
  if (pname == 34975) {
    HEAP32[params >> 2] = data && data["name"];
  } else if (typeof data == "number" || typeof data == "boolean") {
    switch (type) {
      case 0:
        HEAP32[params >> 2] = data;
        break;
      case 2:
        HEAPF32[params >> 2] = data;
        break;
      case 5:
        HEAP32[params >> 2] = Math.fround(data);
        break;
    }
  } else {
    for (var i = 0; i < data.length; i++) {
      switch (type) {
        case 0:
          HEAP32[params + i * 4 >> 2] = data[i];
          break;
        case 2:
          HEAPF32[params + i * 4 >> 2] = data[i];
          break;
        case 5:
          HEAP32[params + i * 4 >> 2] = Math.fround(data[i]);
          break;
      }
    }
  }
};
var _glGetVertexAttribIiv = function _glGetVertexAttribIiv(index, pname, params) {
  emscriptenWebGLGetVertexAttrib(index, pname, params, 0);
};
var _emscripten_glGetVertexAttribIiv = _glGetVertexAttribIiv;
var _glGetVertexAttribIuiv = _glGetVertexAttribIiv;
var _emscripten_glGetVertexAttribIuiv = _glGetVertexAttribIuiv;
var _glGetVertexAttribPointerv = function _glGetVertexAttribPointerv(index, pname, pointer) {
  if (!pointer) {
    GL.recordError(1281);
    return;
  }
  HEAP32[pointer >> 2] = GLctx.getVertexAttribOffset(index, pname);
};
var _emscripten_glGetVertexAttribPointerv = _glGetVertexAttribPointerv;
var _glGetVertexAttribfv = function _glGetVertexAttribfv(index, pname, params) {
  emscriptenWebGLGetVertexAttrib(index, pname, params, 2);
};
var _emscripten_glGetVertexAttribfv = _glGetVertexAttribfv;
var _glGetVertexAttribiv = function _glGetVertexAttribiv(index, pname, params) {
  emscriptenWebGLGetVertexAttrib(index, pname, params, 5);
};
var _emscripten_glGetVertexAttribiv = _glGetVertexAttribiv;
var _glHint = function _glHint(x0, x1) {
  return GLctx.hint(x0, x1);
};
var _emscripten_glHint = _glHint;
var _glInvalidateFramebuffer = function _glInvalidateFramebuffer(target, numAttachments, attachments) {
  var list = tempFixedLengthArray[numAttachments];
  for (var i = 0; i < numAttachments; i++) {
    list[i] = HEAP32[attachments + i * 4 >> 2];
  }
  GLctx.invalidateFramebuffer(target, list);
};
var _emscripten_glInvalidateFramebuffer = _glInvalidateFramebuffer;
var _glInvalidateSubFramebuffer = function _glInvalidateSubFramebuffer(target, numAttachments, attachments, x, y, width, height) {
  var list = tempFixedLengthArray[numAttachments];
  for (var i = 0; i < numAttachments; i++) {
    list[i] = HEAP32[attachments + i * 4 >> 2];
  }
  GLctx.invalidateSubFramebuffer(target, list, x, y, width, height);
};
var _emscripten_glInvalidateSubFramebuffer = _glInvalidateSubFramebuffer;
var _glIsBuffer = function _glIsBuffer(buffer) {
  var b = GL.buffers[buffer];
  if (!b) return 0;
  return GLctx.isBuffer(b);
};
var _emscripten_glIsBuffer = _glIsBuffer;
var _glIsEnabled = function _glIsEnabled(x0) {
  return GLctx.isEnabled(x0);
};
var _emscripten_glIsEnabled = _glIsEnabled;
var _glIsFramebuffer = function _glIsFramebuffer(framebuffer) {
  var fb = GL.framebuffers[framebuffer];
  if (!fb) return 0;
  return GLctx.isFramebuffer(fb);
};
var _emscripten_glIsFramebuffer = _glIsFramebuffer;
var _glIsProgram = function _glIsProgram(program) {
  program = GL.programs[program];
  if (!program) return 0;
  return GLctx.isProgram(program);
};
var _emscripten_glIsProgram = _glIsProgram;
var _glIsQuery = function _glIsQuery(id) {
  var query = GL.queries[id];
  if (!query) return 0;
  return GLctx.isQuery(query);
};
var _emscripten_glIsQuery = _glIsQuery;
var _glIsQueryEXT = function _glIsQueryEXT(id) {
  var query = GL.queries[id];
  if (!query) return 0;
  return GLctx.disjointTimerQueryExt["isQueryEXT"](query);
};
var _emscripten_glIsQueryEXT = _glIsQueryEXT;
var _glIsRenderbuffer = function _glIsRenderbuffer(renderbuffer) {
  var rb = GL.renderbuffers[renderbuffer];
  if (!rb) return 0;
  return GLctx.isRenderbuffer(rb);
};
var _emscripten_glIsRenderbuffer = _glIsRenderbuffer;
var _glIsSampler = function _glIsSampler(id) {
  var sampler = GL.samplers[id];
  if (!sampler) return 0;
  return GLctx.isSampler(sampler);
};
var _emscripten_glIsSampler = _glIsSampler;
var _glIsShader = function _glIsShader(shader) {
  var s = GL.shaders[shader];
  if (!s) return 0;
  return GLctx.isShader(s);
};
var _emscripten_glIsShader = _glIsShader;
var _glIsSync = function _glIsSync(sync) {
  return GLctx.isSync(GL.syncs[sync]);
};
var _emscripten_glIsSync = _glIsSync;
var _glIsTexture = function _glIsTexture(id) {
  var texture = GL.textures[id];
  if (!texture) return 0;
  return GLctx.isTexture(texture);
};
var _emscripten_glIsTexture = _glIsTexture;
var _glIsTransformFeedback = function _glIsTransformFeedback(id) {
  return GLctx.isTransformFeedback(GL.transformFeedbacks[id]);
};
var _emscripten_glIsTransformFeedback = _glIsTransformFeedback;
var _glIsVertexArray = function _glIsVertexArray(array) {
  var vao = GL.vaos[array];
  if (!vao) return 0;
  return GLctx.isVertexArray(vao);
};
var _emscripten_glIsVertexArray = _glIsVertexArray;
var _glIsVertexArrayOES = _glIsVertexArray;
var _emscripten_glIsVertexArrayOES = _glIsVertexArrayOES;
var _glLineWidth = function _glLineWidth(x0) {
  return GLctx.lineWidth(x0);
};
var _emscripten_glLineWidth = _glLineWidth;
var _glLinkProgram = function _glLinkProgram(program) {
  program = GL.programs[program];
  GLctx.linkProgram(program);
  program.uniformLocsById = 0;
  program.uniformSizeAndIdsByName = {};
};
var _emscripten_glLinkProgram = _glLinkProgram;
var _glPauseTransformFeedback = function _glPauseTransformFeedback() {
  return GLctx.pauseTransformFeedback();
};
var _emscripten_glPauseTransformFeedback = _glPauseTransformFeedback;
var _glPixelStorei = function _glPixelStorei(pname, param) {
  if (pname == 3317) {
    GL.unpackAlignment = param;
  }
  GLctx.pixelStorei(pname, param);
};
var _emscripten_glPixelStorei = _glPixelStorei;
var _glPolygonOffset = function _glPolygonOffset(x0, x1) {
  return GLctx.polygonOffset(x0, x1);
};
var _emscripten_glPolygonOffset = _glPolygonOffset;
var _glProgramBinary = function _glProgramBinary(program, binaryFormat, binary, length) {
  GL.recordError(1280);
};
var _emscripten_glProgramBinary = _glProgramBinary;
var _glProgramParameteri = function _glProgramParameteri(program, pname, value) {
  GL.recordError(1280);
};
var _emscripten_glProgramParameteri = _glProgramParameteri;
var _glQueryCounterEXT = function _glQueryCounterEXT(id, target) {
  GLctx.disjointTimerQueryExt["queryCounterEXT"](GL.queries[id], target);
};
var _emscripten_glQueryCounterEXT = _glQueryCounterEXT;
var _glReadBuffer = function _glReadBuffer(x0) {
  return GLctx.readBuffer(x0);
};
var _emscripten_glReadBuffer = _glReadBuffer;
var computeUnpackAlignedImageSize = function computeUnpackAlignedImageSize(width, height, sizePerPixel, alignment) {
  function roundedToNextMultipleOf(x, y) {
    return x + y - 1 & -y;
  }
  var plainRowSize = width * sizePerPixel;
  var alignedRowSize = roundedToNextMultipleOf(plainRowSize, alignment);
  return height * alignedRowSize;
};
var colorChannelsInGlTextureFormat = function colorChannelsInGlTextureFormat(format) {
  var colorChannels = {
    5: 3,
    6: 4,
    8: 2,
    29502: 3,
    29504: 4,
    26917: 2,
    26918: 2,
    29846: 3,
    29847: 4
  };
  return colorChannels[format - 6402] || 1;
};
var heapObjectForWebGLType = function heapObjectForWebGLType(type) {
  type -= 5120;
  if (type == 0) return HEAP8;
  if (type == 1) return HEAPU8;
  if (type == 2) return HEAP16;
  if (type == 4) return HEAP32;
  if (type == 6) return HEAPF32;
  if (type == 5 || type == 28922 || type == 28520 || type == 30779 || type == 30782) return HEAPU32;
  return HEAPU16;
};
var toTypedArrayIndex = function toTypedArrayIndex(pointer, heap) {
  return pointer >>> 31 - Math.clz32(heap.BYTES_PER_ELEMENT);
};
var emscriptenWebGLGetTexPixelData = function emscriptenWebGLGetTexPixelData(type, format, width, height, pixels, internalFormat) {
  var heap = heapObjectForWebGLType(type);
  var sizePerPixel = colorChannelsInGlTextureFormat(format) * heap.BYTES_PER_ELEMENT;
  var bytes = computeUnpackAlignedImageSize(width, height, sizePerPixel, GL.unpackAlignment);
  return heap.subarray(toTypedArrayIndex(pixels, heap), toTypedArrayIndex(pixels + bytes, heap));
};
var _glReadPixels = function _glReadPixels(x, y, width, height, format, type, pixels) {
  if (GL.currentContext.version >= 2) {
    if (GLctx.currentPixelPackBufferBinding) {
      GLctx.readPixels(x, y, width, height, format, type, pixels);
    } else {
      var heap = heapObjectForWebGLType(type);
      var target = toTypedArrayIndex(pixels, heap);
      GLctx.readPixels(x, y, width, height, format, type, heap, target);
    }
    return;
  }
  var pixelData = emscriptenWebGLGetTexPixelData(type, format, width, height, pixels, format);
  if (!pixelData) {
    GL.recordError(1280);
    return;
  }
  GLctx.readPixels(x, y, width, height, format, type, pixelData);
};
var _emscripten_glReadPixels = _glReadPixels;
var _glReleaseShaderCompiler = function _glReleaseShaderCompiler() {};
var _emscripten_glReleaseShaderCompiler = _glReleaseShaderCompiler;
var _glRenderbufferStorage = function _glRenderbufferStorage(x0, x1, x2, x3) {
  return GLctx.renderbufferStorage(x0, x1, x2, x3);
};
var _emscripten_glRenderbufferStorage = _glRenderbufferStorage;
var _glRenderbufferStorageMultisample = function _glRenderbufferStorageMultisample(x0, x1, x2, x3, x4) {
  return GLctx.renderbufferStorageMultisample(x0, x1, x2, x3, x4);
};
var _emscripten_glRenderbufferStorageMultisample = _glRenderbufferStorageMultisample;
var _glResumeTransformFeedback = function _glResumeTransformFeedback() {
  return GLctx.resumeTransformFeedback();
};
var _emscripten_glResumeTransformFeedback = _glResumeTransformFeedback;
var _glSampleCoverage = function _glSampleCoverage(value, invert) {
  GLctx.sampleCoverage(value, !!invert);
};
var _emscripten_glSampleCoverage = _glSampleCoverage;
var _glSamplerParameterf = function _glSamplerParameterf(sampler, pname, param) {
  GLctx.samplerParameterf(GL.samplers[sampler], pname, param);
};
var _emscripten_glSamplerParameterf = _glSamplerParameterf;
var _glSamplerParameterfv = function _glSamplerParameterfv(sampler, pname, params) {
  var param = HEAPF32[params >> 2];
  GLctx.samplerParameterf(GL.samplers[sampler], pname, param);
};
var _emscripten_glSamplerParameterfv = _glSamplerParameterfv;
var _glSamplerParameteri = function _glSamplerParameteri(sampler, pname, param) {
  GLctx.samplerParameteri(GL.samplers[sampler], pname, param);
};
var _emscripten_glSamplerParameteri = _glSamplerParameteri;
var _glSamplerParameteriv = function _glSamplerParameteriv(sampler, pname, params) {
  var param = HEAP32[params >> 2];
  GLctx.samplerParameteri(GL.samplers[sampler], pname, param);
};
var _emscripten_glSamplerParameteriv = _glSamplerParameteriv;
var _glScissor = function _glScissor(x0, x1, x2, x3) {
  return GLctx.scissor(x0, x1, x2, x3);
};
var _emscripten_glScissor = _glScissor;
var _glShaderBinary = function _glShaderBinary(count, shaders, binaryformat, binary, length) {
  GL.recordError(1280);
};
var _emscripten_glShaderBinary = _glShaderBinary;
var _glShaderSource = function _glShaderSource(shader, count, string, length) {
  var source = GL.getSource(shader, count, string, length);
  GLctx.shaderSource(GL.shaders[shader], source);
};
var _emscripten_glShaderSource = _glShaderSource;
var _glStencilFunc = function _glStencilFunc(x0, x1, x2) {
  return GLctx.stencilFunc(x0, x1, x2);
};
var _emscripten_glStencilFunc = _glStencilFunc;
var _glStencilFuncSeparate = function _glStencilFuncSeparate(x0, x1, x2, x3) {
  return GLctx.stencilFuncSeparate(x0, x1, x2, x3);
};
var _emscripten_glStencilFuncSeparate = _glStencilFuncSeparate;
var _glStencilMask = function _glStencilMask(x0) {
  return GLctx.stencilMask(x0);
};
var _emscripten_glStencilMask = _glStencilMask;
var _glStencilMaskSeparate = function _glStencilMaskSeparate(x0, x1) {
  return GLctx.stencilMaskSeparate(x0, x1);
};
var _emscripten_glStencilMaskSeparate = _glStencilMaskSeparate;
var _glStencilOp = function _glStencilOp(x0, x1, x2) {
  return GLctx.stencilOp(x0, x1, x2);
};
var _emscripten_glStencilOp = _glStencilOp;
var _glStencilOpSeparate = function _glStencilOpSeparate(x0, x1, x2, x3) {
  return GLctx.stencilOpSeparate(x0, x1, x2, x3);
};
var _emscripten_glStencilOpSeparate = _glStencilOpSeparate;
var _glTexImage2D = function _glTexImage2D(target, level, internalFormat, width, height, border, format, type, pixels) {
  if (GL.currentContext.version >= 2) {
    if (GLctx.currentPixelUnpackBufferBinding) {
      GLctx.texImage2D(target, level, internalFormat, width, height, border, format, type, pixels);
    } else if (pixels) {
      var heap = heapObjectForWebGLType(type);
      GLctx.texImage2D(target, level, internalFormat, width, height, border, format, type, heap, toTypedArrayIndex(pixels, heap));
    } else {
      GLctx.texImage2D(target, level, internalFormat, width, height, border, format, type, null);
    }
    return;
  }
  GLctx.texImage2D(target, level, internalFormat, width, height, border, format, type, pixels ? emscriptenWebGLGetTexPixelData(type, format, width, height, pixels, internalFormat) : null);
};
var _emscripten_glTexImage2D = _glTexImage2D;
var _glTexImage3D = function _glTexImage3D(target, level, internalFormat, width, height, depth, border, format, type, pixels) {
  if (GLctx.currentPixelUnpackBufferBinding) {
    GLctx.texImage3D(target, level, internalFormat, width, height, depth, border, format, type, pixels);
  } else if (pixels) {
    var heap = heapObjectForWebGLType(type);
    GLctx.texImage3D(target, level, internalFormat, width, height, depth, border, format, type, heap, toTypedArrayIndex(pixels, heap));
  } else {
    GLctx.texImage3D(target, level, internalFormat, width, height, depth, border, format, type, null);
  }
};
var _emscripten_glTexImage3D = _glTexImage3D;
var _glTexParameterf = function _glTexParameterf(x0, x1, x2) {
  return GLctx.texParameterf(x0, x1, x2);
};
var _emscripten_glTexParameterf = _glTexParameterf;
var _glTexParameterfv = function _glTexParameterfv(target, pname, params) {
  var param = HEAPF32[params >> 2];
  GLctx.texParameterf(target, pname, param);
};
var _emscripten_glTexParameterfv = _glTexParameterfv;
var _glTexParameteri = function _glTexParameteri(x0, x1, x2) {
  return GLctx.texParameteri(x0, x1, x2);
};
var _emscripten_glTexParameteri = _glTexParameteri;
var _glTexParameteriv = function _glTexParameteriv(target, pname, params) {
  var param = HEAP32[params >> 2];
  GLctx.texParameteri(target, pname, param);
};
var _emscripten_glTexParameteriv = _glTexParameteriv;
var _glTexStorage2D = function _glTexStorage2D(x0, x1, x2, x3, x4) {
  return GLctx.texStorage2D(x0, x1, x2, x3, x4);
};
var _emscripten_glTexStorage2D = _glTexStorage2D;
var _glTexStorage3D = function _glTexStorage3D(x0, x1, x2, x3, x4, x5) {
  return GLctx.texStorage3D(x0, x1, x2, x3, x4, x5);
};
var _emscripten_glTexStorage3D = _glTexStorage3D;
var _glTexSubImage2D = function _glTexSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels) {
  if (GL.currentContext.version >= 2) {
    if (GLctx.currentPixelUnpackBufferBinding) {
      GLctx.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixels);
    } else if (pixels) {
      var heap = heapObjectForWebGLType(type);
      GLctx.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, heap, toTypedArrayIndex(pixels, heap));
      return;
    }
  }
  var pixelData = pixels ? emscriptenWebGLGetTexPixelData(type, format, width, height, pixels, 0) : null;
  GLctx.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, pixelData);
};
var _emscripten_glTexSubImage2D = _glTexSubImage2D;
var _glTexSubImage3D = function _glTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels) {
  if (GLctx.currentPixelUnpackBufferBinding) {
    GLctx.texSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, pixels);
  } else if (pixels) {
    var heap = heapObjectForWebGLType(type);
    GLctx.texSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, heap, toTypedArrayIndex(pixels, heap));
  } else {
    GLctx.texSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, null);
  }
};
var _emscripten_glTexSubImage3D = _glTexSubImage3D;
var _glTransformFeedbackVaryings = function _glTransformFeedbackVaryings(program, count, varyings, bufferMode) {
  program = GL.programs[program];
  var vars = [];
  for (var i = 0; i < count; i++) vars.push(UTF8ToString(HEAP32[varyings + i * 4 >> 2]));
  GLctx.transformFeedbackVaryings(program, vars, bufferMode);
};
var _emscripten_glTransformFeedbackVaryings = _glTransformFeedbackVaryings;
var _glUniform1f = function _glUniform1f(location, v0) {
  GLctx.uniform1f(webglGetUniformLocation(location), v0);
};
var _emscripten_glUniform1f = _glUniform1f;
var miniTempWebGLFloatBuffers = [];
var _glUniform1fv = function _glUniform1fv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform1fv(webglGetUniformLocation(location), HEAPF32, value >> 2, count);
    return;
  }
  if (count <= 288) {
    var view = miniTempWebGLFloatBuffers[count - 1];
    for (var i = 0; i < count; ++i) {
      view[i] = HEAPF32[value + 4 * i >> 2];
    }
  } else {
    var view = HEAPF32.subarray(value >> 2, value + count * 4 >> 2);
  }
  GLctx.uniform1fv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform1fv = _glUniform1fv;
var _glUniform1i = function _glUniform1i(location, v0) {
  GLctx.uniform1i(webglGetUniformLocation(location), v0);
};
var _emscripten_glUniform1i = _glUniform1i;
var miniTempWebGLIntBuffers = [];
var _glUniform1iv = function _glUniform1iv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform1iv(webglGetUniformLocation(location), HEAP32, value >> 2, count);
    return;
  }
  if (count <= 288) {
    var view = miniTempWebGLIntBuffers[count - 1];
    for (var i = 0; i < count; ++i) {
      view[i] = HEAP32[value + 4 * i >> 2];
    }
  } else {
    var view = HEAP32.subarray(value >> 2, value + count * 4 >> 2);
  }
  GLctx.uniform1iv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform1iv = _glUniform1iv;
var _glUniform1ui = function _glUniform1ui(location, v0) {
  GLctx.uniform1ui(webglGetUniformLocation(location), v0);
};
var _emscripten_glUniform1ui = _glUniform1ui;
var _glUniform1uiv = function _glUniform1uiv(location, count, value) {
  count && GLctx.uniform1uiv(webglGetUniformLocation(location), HEAPU32, value >> 2, count);
};
var _emscripten_glUniform1uiv = _glUniform1uiv;
var _glUniform2f = function _glUniform2f(location, v0, v1) {
  GLctx.uniform2f(webglGetUniformLocation(location), v0, v1);
};
var _emscripten_glUniform2f = _glUniform2f;
var _glUniform2fv = function _glUniform2fv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform2fv(webglGetUniformLocation(location), HEAPF32, value >> 2, count * 2);
    return;
  }
  if (count <= 144) {
    var view = miniTempWebGLFloatBuffers[2 * count - 1];
    for (var i = 0; i < 2 * count; i += 2) {
      view[i] = HEAPF32[value + 4 * i >> 2];
      view[i + 1] = HEAPF32[value + (4 * i + 4) >> 2];
    }
  } else {
    var view = HEAPF32.subarray(value >> 2, value + count * 8 >> 2);
  }
  GLctx.uniform2fv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform2fv = _glUniform2fv;
var _glUniform2i = function _glUniform2i(location, v0, v1) {
  GLctx.uniform2i(webglGetUniformLocation(location), v0, v1);
};
var _emscripten_glUniform2i = _glUniform2i;
var _glUniform2iv = function _glUniform2iv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform2iv(webglGetUniformLocation(location), HEAP32, value >> 2, count * 2);
    return;
  }
  if (count <= 144) {
    var view = miniTempWebGLIntBuffers[2 * count - 1];
    for (var i = 0; i < 2 * count; i += 2) {
      view[i] = HEAP32[value + 4 * i >> 2];
      view[i + 1] = HEAP32[value + (4 * i + 4) >> 2];
    }
  } else {
    var view = HEAP32.subarray(value >> 2, value + count * 8 >> 2);
  }
  GLctx.uniform2iv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform2iv = _glUniform2iv;
var _glUniform2ui = function _glUniform2ui(location, v0, v1) {
  GLctx.uniform2ui(webglGetUniformLocation(location), v0, v1);
};
var _emscripten_glUniform2ui = _glUniform2ui;
var _glUniform2uiv = function _glUniform2uiv(location, count, value) {
  count && GLctx.uniform2uiv(webglGetUniformLocation(location), HEAPU32, value >> 2, count * 2);
};
var _emscripten_glUniform2uiv = _glUniform2uiv;
var _glUniform3f = function _glUniform3f(location, v0, v1, v2) {
  GLctx.uniform3f(webglGetUniformLocation(location), v0, v1, v2);
};
var _emscripten_glUniform3f = _glUniform3f;
var _glUniform3fv = function _glUniform3fv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform3fv(webglGetUniformLocation(location), HEAPF32, value >> 2, count * 3);
    return;
  }
  if (count <= 96) {
    var view = miniTempWebGLFloatBuffers[3 * count - 1];
    for (var i = 0; i < 3 * count; i += 3) {
      view[i] = HEAPF32[value + 4 * i >> 2];
      view[i + 1] = HEAPF32[value + (4 * i + 4) >> 2];
      view[i + 2] = HEAPF32[value + (4 * i + 8) >> 2];
    }
  } else {
    var view = HEAPF32.subarray(value >> 2, value + count * 12 >> 2);
  }
  GLctx.uniform3fv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform3fv = _glUniform3fv;
var _glUniform3i = function _glUniform3i(location, v0, v1, v2) {
  GLctx.uniform3i(webglGetUniformLocation(location), v0, v1, v2);
};
var _emscripten_glUniform3i = _glUniform3i;
var _glUniform3iv = function _glUniform3iv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform3iv(webglGetUniformLocation(location), HEAP32, value >> 2, count * 3);
    return;
  }
  if (count <= 96) {
    var view = miniTempWebGLIntBuffers[3 * count - 1];
    for (var i = 0; i < 3 * count; i += 3) {
      view[i] = HEAP32[value + 4 * i >> 2];
      view[i + 1] = HEAP32[value + (4 * i + 4) >> 2];
      view[i + 2] = HEAP32[value + (4 * i + 8) >> 2];
    }
  } else {
    var view = HEAP32.subarray(value >> 2, value + count * 12 >> 2);
  }
  GLctx.uniform3iv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform3iv = _glUniform3iv;
var _glUniform3ui = function _glUniform3ui(location, v0, v1, v2) {
  GLctx.uniform3ui(webglGetUniformLocation(location), v0, v1, v2);
};
var _emscripten_glUniform3ui = _glUniform3ui;
var _glUniform3uiv = function _glUniform3uiv(location, count, value) {
  count && GLctx.uniform3uiv(webglGetUniformLocation(location), HEAPU32, value >> 2, count * 3);
};
var _emscripten_glUniform3uiv = _glUniform3uiv;
var _glUniform4f = function _glUniform4f(location, v0, v1, v2, v3) {
  GLctx.uniform4f(webglGetUniformLocation(location), v0, v1, v2, v3);
};
var _emscripten_glUniform4f = _glUniform4f;
var _glUniform4fv = function _glUniform4fv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform4fv(webglGetUniformLocation(location), HEAPF32, value >> 2, count * 4);
    return;
  }
  if (count <= 72) {
    var view = miniTempWebGLFloatBuffers[4 * count - 1];
    var heap = HEAPF32;
    value = value >> 2;
    for (var i = 0; i < 4 * count; i += 4) {
      var dst = value + i;
      view[i] = heap[dst];
      view[i + 1] = heap[dst + 1];
      view[i + 2] = heap[dst + 2];
      view[i + 3] = heap[dst + 3];
    }
  } else {
    var view = HEAPF32.subarray(value >> 2, value + count * 16 >> 2);
  }
  GLctx.uniform4fv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform4fv = _glUniform4fv;
var _glUniform4i = function _glUniform4i(location, v0, v1, v2, v3) {
  GLctx.uniform4i(webglGetUniformLocation(location), v0, v1, v2, v3);
};
var _emscripten_glUniform4i = _glUniform4i;
var _glUniform4iv = function _glUniform4iv(location, count, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniform4iv(webglGetUniformLocation(location), HEAP32, value >> 2, count * 4);
    return;
  }
  if (count <= 72) {
    var view = miniTempWebGLIntBuffers[4 * count - 1];
    for (var i = 0; i < 4 * count; i += 4) {
      view[i] = HEAP32[value + 4 * i >> 2];
      view[i + 1] = HEAP32[value + (4 * i + 4) >> 2];
      view[i + 2] = HEAP32[value + (4 * i + 8) >> 2];
      view[i + 3] = HEAP32[value + (4 * i + 12) >> 2];
    }
  } else {
    var view = HEAP32.subarray(value >> 2, value + count * 16 >> 2);
  }
  GLctx.uniform4iv(webglGetUniformLocation(location), view);
};
var _emscripten_glUniform4iv = _glUniform4iv;
var _glUniform4ui = function _glUniform4ui(location, v0, v1, v2, v3) {
  GLctx.uniform4ui(webglGetUniformLocation(location), v0, v1, v2, v3);
};
var _emscripten_glUniform4ui = _glUniform4ui;
var _glUniform4uiv = function _glUniform4uiv(location, count, value) {
  count && GLctx.uniform4uiv(webglGetUniformLocation(location), HEAPU32, value >> 2, count * 4);
};
var _emscripten_glUniform4uiv = _glUniform4uiv;
var _glUniformBlockBinding = function _glUniformBlockBinding(program, uniformBlockIndex, uniformBlockBinding) {
  program = GL.programs[program];
  GLctx.uniformBlockBinding(program, uniformBlockIndex, uniformBlockBinding);
};
var _emscripten_glUniformBlockBinding = _glUniformBlockBinding;
var _glUniformMatrix2fv = function _glUniformMatrix2fv(location, count, transpose, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniformMatrix2fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 4);
    return;
  }
  if (count <= 72) {
    var view = miniTempWebGLFloatBuffers[4 * count - 1];
    for (var i = 0; i < 4 * count; i += 4) {
      view[i] = HEAPF32[value + 4 * i >> 2];
      view[i + 1] = HEAPF32[value + (4 * i + 4) >> 2];
      view[i + 2] = HEAPF32[value + (4 * i + 8) >> 2];
      view[i + 3] = HEAPF32[value + (4 * i + 12) >> 2];
    }
  } else {
    var view = HEAPF32.subarray(value >> 2, value + count * 16 >> 2);
  }
  GLctx.uniformMatrix2fv(webglGetUniformLocation(location), !!transpose, view);
};
var _emscripten_glUniformMatrix2fv = _glUniformMatrix2fv;
var _glUniformMatrix2x3fv = function _glUniformMatrix2x3fv(location, count, transpose, value) {
  count && GLctx.uniformMatrix2x3fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 6);
};
var _emscripten_glUniformMatrix2x3fv = _glUniformMatrix2x3fv;
var _glUniformMatrix2x4fv = function _glUniformMatrix2x4fv(location, count, transpose, value) {
  count && GLctx.uniformMatrix2x4fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 8);
};
var _emscripten_glUniformMatrix2x4fv = _glUniformMatrix2x4fv;
var _glUniformMatrix3fv = function _glUniformMatrix3fv(location, count, transpose, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniformMatrix3fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 9);
    return;
  }
  if (count <= 32) {
    var view = miniTempWebGLFloatBuffers[9 * count - 1];
    for (var i = 0; i < 9 * count; i += 9) {
      view[i] = HEAPF32[value + 4 * i >> 2];
      view[i + 1] = HEAPF32[value + (4 * i + 4) >> 2];
      view[i + 2] = HEAPF32[value + (4 * i + 8) >> 2];
      view[i + 3] = HEAPF32[value + (4 * i + 12) >> 2];
      view[i + 4] = HEAPF32[value + (4 * i + 16) >> 2];
      view[i + 5] = HEAPF32[value + (4 * i + 20) >> 2];
      view[i + 6] = HEAPF32[value + (4 * i + 24) >> 2];
      view[i + 7] = HEAPF32[value + (4 * i + 28) >> 2];
      view[i + 8] = HEAPF32[value + (4 * i + 32) >> 2];
    }
  } else {
    var view = HEAPF32.subarray(value >> 2, value + count * 36 >> 2);
  }
  GLctx.uniformMatrix3fv(webglGetUniformLocation(location), !!transpose, view);
};
var _emscripten_glUniformMatrix3fv = _glUniformMatrix3fv;
var _glUniformMatrix3x2fv = function _glUniformMatrix3x2fv(location, count, transpose, value) {
  count && GLctx.uniformMatrix3x2fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 6);
};
var _emscripten_glUniformMatrix3x2fv = _glUniformMatrix3x2fv;
var _glUniformMatrix3x4fv = function _glUniformMatrix3x4fv(location, count, transpose, value) {
  count && GLctx.uniformMatrix3x4fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 12);
};
var _emscripten_glUniformMatrix3x4fv = _glUniformMatrix3x4fv;
var _glUniformMatrix4fv = function _glUniformMatrix4fv(location, count, transpose, value) {
  if (GL.currentContext.version >= 2) {
    count && GLctx.uniformMatrix4fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 16);
    return;
  }
  if (count <= 18) {
    var view = miniTempWebGLFloatBuffers[16 * count - 1];
    var heap = HEAPF32;
    value = value >> 2;
    for (var i = 0; i < 16 * count; i += 16) {
      var dst = value + i;
      view[i] = heap[dst];
      view[i + 1] = heap[dst + 1];
      view[i + 2] = heap[dst + 2];
      view[i + 3] = heap[dst + 3];
      view[i + 4] = heap[dst + 4];
      view[i + 5] = heap[dst + 5];
      view[i + 6] = heap[dst + 6];
      view[i + 7] = heap[dst + 7];
      view[i + 8] = heap[dst + 8];
      view[i + 9] = heap[dst + 9];
      view[i + 10] = heap[dst + 10];
      view[i + 11] = heap[dst + 11];
      view[i + 12] = heap[dst + 12];
      view[i + 13] = heap[dst + 13];
      view[i + 14] = heap[dst + 14];
      view[i + 15] = heap[dst + 15];
    }
  } else {
    var view = HEAPF32.subarray(value >> 2, value + count * 64 >> 2);
  }
  GLctx.uniformMatrix4fv(webglGetUniformLocation(location), !!transpose, view);
};
var _emscripten_glUniformMatrix4fv = _glUniformMatrix4fv;
var _glUniformMatrix4x2fv = function _glUniformMatrix4x2fv(location, count, transpose, value) {
  count && GLctx.uniformMatrix4x2fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 8);
};
var _emscripten_glUniformMatrix4x2fv = _glUniformMatrix4x2fv;
var _glUniformMatrix4x3fv = function _glUniformMatrix4x3fv(location, count, transpose, value) {
  count && GLctx.uniformMatrix4x3fv(webglGetUniformLocation(location), !!transpose, HEAPF32, value >> 2, count * 12);
};
var _emscripten_glUniformMatrix4x3fv = _glUniformMatrix4x3fv;
var _glUseProgram = function _glUseProgram(program) {
  program = GL.programs[program];
  GLctx.useProgram(program);
  GLctx.currentProgram = program;
};
var _emscripten_glUseProgram = _glUseProgram;
var _glValidateProgram = function _glValidateProgram(program) {
  GLctx.validateProgram(GL.programs[program]);
};
var _emscripten_glValidateProgram = _glValidateProgram;
var _glVertexAttrib1f = function _glVertexAttrib1f(x0, x1) {
  return GLctx.vertexAttrib1f(x0, x1);
};
var _emscripten_glVertexAttrib1f = _glVertexAttrib1f;
var _glVertexAttrib1fv = function _glVertexAttrib1fv(index, v) {
  GLctx.vertexAttrib1f(index, HEAPF32[v >> 2]);
};
var _emscripten_glVertexAttrib1fv = _glVertexAttrib1fv;
var _glVertexAttrib2f = function _glVertexAttrib2f(x0, x1, x2) {
  return GLctx.vertexAttrib2f(x0, x1, x2);
};
var _emscripten_glVertexAttrib2f = _glVertexAttrib2f;
var _glVertexAttrib2fv = function _glVertexAttrib2fv(index, v) {
  GLctx.vertexAttrib2f(index, HEAPF32[v >> 2], HEAPF32[v + 4 >> 2]);
};
var _emscripten_glVertexAttrib2fv = _glVertexAttrib2fv;
var _glVertexAttrib3f = function _glVertexAttrib3f(x0, x1, x2, x3) {
  return GLctx.vertexAttrib3f(x0, x1, x2, x3);
};
var _emscripten_glVertexAttrib3f = _glVertexAttrib3f;
var _glVertexAttrib3fv = function _glVertexAttrib3fv(index, v) {
  GLctx.vertexAttrib3f(index, HEAPF32[v >> 2], HEAPF32[v + 4 >> 2], HEAPF32[v + 8 >> 2]);
};
var _emscripten_glVertexAttrib3fv = _glVertexAttrib3fv;
var _glVertexAttrib4f = function _glVertexAttrib4f(x0, x1, x2, x3, x4) {
  return GLctx.vertexAttrib4f(x0, x1, x2, x3, x4);
};
var _emscripten_glVertexAttrib4f = _glVertexAttrib4f;
var _glVertexAttrib4fv = function _glVertexAttrib4fv(index, v) {
  GLctx.vertexAttrib4f(index, HEAPF32[v >> 2], HEAPF32[v + 4 >> 2], HEAPF32[v + 8 >> 2], HEAPF32[v + 12 >> 2]);
};
var _emscripten_glVertexAttrib4fv = _glVertexAttrib4fv;
var _glVertexAttribDivisor = function _glVertexAttribDivisor(index, divisor) {
  GLctx.vertexAttribDivisor(index, divisor);
};
var _emscripten_glVertexAttribDivisor = _glVertexAttribDivisor;
var _glVertexAttribDivisorANGLE = _glVertexAttribDivisor;
var _emscripten_glVertexAttribDivisorANGLE = _glVertexAttribDivisorANGLE;
var _glVertexAttribDivisorARB = _glVertexAttribDivisor;
var _emscripten_glVertexAttribDivisorARB = _glVertexAttribDivisorARB;
var _glVertexAttribDivisorEXT = _glVertexAttribDivisor;
var _emscripten_glVertexAttribDivisorEXT = _glVertexAttribDivisorEXT;
var _glVertexAttribDivisorNV = _glVertexAttribDivisor;
var _emscripten_glVertexAttribDivisorNV = _glVertexAttribDivisorNV;
var _glVertexAttribI4i = function _glVertexAttribI4i(x0, x1, x2, x3, x4) {
  return GLctx.vertexAttribI4i(x0, x1, x2, x3, x4);
};
var _emscripten_glVertexAttribI4i = _glVertexAttribI4i;
var _glVertexAttribI4iv = function _glVertexAttribI4iv(index, v) {
  GLctx.vertexAttribI4i(index, HEAP32[v >> 2], HEAP32[v + 4 >> 2], HEAP32[v + 8 >> 2], HEAP32[v + 12 >> 2]);
};
var _emscripten_glVertexAttribI4iv = _glVertexAttribI4iv;
var _glVertexAttribI4ui = function _glVertexAttribI4ui(x0, x1, x2, x3, x4) {
  return GLctx.vertexAttribI4ui(x0, x1, x2, x3, x4);
};
var _emscripten_glVertexAttribI4ui = _glVertexAttribI4ui;
var _glVertexAttribI4uiv = function _glVertexAttribI4uiv(index, v) {
  GLctx.vertexAttribI4ui(index, HEAPU32[v >> 2], HEAPU32[v + 4 >> 2], HEAPU32[v + 8 >> 2], HEAPU32[v + 12 >> 2]);
};
var _emscripten_glVertexAttribI4uiv = _glVertexAttribI4uiv;
var _glVertexAttribIPointer = function _glVertexAttribIPointer(index, size, type, stride, ptr) {
  GLctx.vertexAttribIPointer(index, size, type, stride, ptr);
};
var _emscripten_glVertexAttribIPointer = _glVertexAttribIPointer;
var _glVertexAttribPointer = function _glVertexAttribPointer(index, size, type, normalized, stride, ptr) {
  GLctx.vertexAttribPointer(index, size, type, !!normalized, stride, ptr);
};
var _emscripten_glVertexAttribPointer = _glVertexAttribPointer;
var _glViewport = function _glViewport(x0, x1, x2, x3) {
  return GLctx.viewport(x0, x1, x2, x3);
};
var _emscripten_glViewport = _glViewport;
var _glWaitSync = function _glWaitSync(sync, flags, timeout_low, timeout_high) {
  var timeout = convertI32PairToI53(timeout_low, timeout_high);
  GLctx.waitSync(GL.syncs[sync], flags, timeout);
};
var _emscripten_glWaitSync = _glWaitSync;
var _emscripten_memcpy_js = Uint8Array.prototype.copyWithin ? function (dest, src, num) {
  return HEAPU8.copyWithin(dest, src, src + num);
} : function (dest, src, num) {
  return HEAPU8.set(HEAPU8.subarray(src, src + num), dest);
};
var _emscripten_pause_main_loop = function _emscripten_pause_main_loop() {
  Browser.mainLoop.pause();
};
var growMemory = function growMemory(size) {
  var b = wasmMemory.buffer;
  var pages = (size - b.byteLength + 65535) / 65536;
  try {
    wasmMemory.grow(pages);
    updateMemoryViews();
    return 1;
  } catch (e) {}
};
var _emscripten_resize_heap = function _emscripten_resize_heap(requestedSize) {
  var oldSize = HEAPU8.length;
  requestedSize >>>= 0;
  var maxHeapSize = getHeapMax();
  if (requestedSize > maxHeapSize) {
    return false;
  }
  var alignUp = function alignUp(x, multiple) {
    return x + (multiple - x % multiple) % multiple;
  };
  for (var cutDown = 1; cutDown <= 4; cutDown *= 2) {
    var overGrownHeapSize = oldSize * (1 + .2 / cutDown);
    overGrownHeapSize = Math.min(overGrownHeapSize, requestedSize + 100663296);
    var newSize = Math.min(maxHeapSize, alignUp(Math.max(requestedSize, overGrownHeapSize), 65536));
    var replacement = growMemory(newSize);
    if (replacement) {
      return true;
    }
  }
  return false;
};
var _emscripten_set_main_loop_arg = function _emscripten_set_main_loop_arg(func, arg, fps, simulateInfiniteLoop) {
  var browserIterationFunc = function browserIterationFunc() {
    return getWasmTableEntry(func)(arg);
  };
  setMainLoop(browserIterationFunc, fps, simulateInfiniteLoop, arg);
};
var webgl_enable_ANGLE_instanced_arrays = function webgl_enable_ANGLE_instanced_arrays(ctx) {
  var ext = ctx.getExtension("ANGLE_instanced_arrays");
  if (ext) {
    ctx["vertexAttribDivisor"] = function (index, divisor) {
      return ext["vertexAttribDivisorANGLE"](index, divisor);
    };
    ctx["drawArraysInstanced"] = function (mode, first, count, primcount) {
      return ext["drawArraysInstancedANGLE"](mode, first, count, primcount);
    };
    ctx["drawElementsInstanced"] = function (mode, count, type, indices, primcount) {
      return ext["drawElementsInstancedANGLE"](mode, count, type, indices, primcount);
    };
    return 1;
  }
};
var webgl_enable_OES_vertex_array_object = function webgl_enable_OES_vertex_array_object(ctx) {
  var ext = ctx.getExtension("OES_vertex_array_object");
  if (ext) {
    ctx["createVertexArray"] = function () {
      return ext["createVertexArrayOES"]();
    };
    ctx["deleteVertexArray"] = function (vao) {
      return ext["deleteVertexArrayOES"](vao);
    };
    ctx["bindVertexArray"] = function (vao) {
      return ext["bindVertexArrayOES"](vao);
    };
    ctx["isVertexArray"] = function (vao) {
      return ext["isVertexArrayOES"](vao);
    };
    return 1;
  }
};
var webgl_enable_WEBGL_draw_buffers = function webgl_enable_WEBGL_draw_buffers(ctx) {
  var ext = ctx.getExtension("WEBGL_draw_buffers");
  if (ext) {
    ctx["drawBuffers"] = function (n, bufs) {
      return ext["drawBuffersWEBGL"](n, bufs);
    };
    return 1;
  }
};
var webgl_enable_WEBGL_draw_instanced_base_vertex_base_instance = function webgl_enable_WEBGL_draw_instanced_base_vertex_base_instance(ctx) {
  return !!(ctx.dibvbi = ctx.getExtension("WEBGL_draw_instanced_base_vertex_base_instance"));
};
var webgl_enable_WEBGL_multi_draw_instanced_base_vertex_base_instance = function webgl_enable_WEBGL_multi_draw_instanced_base_vertex_base_instance(ctx) {
  return !!(ctx.mdibvbi = ctx.getExtension("WEBGL_multi_draw_instanced_base_vertex_base_instance"));
};
var webgl_enable_WEBGL_multi_draw = function webgl_enable_WEBGL_multi_draw(ctx) {
  return !!(ctx.multiDrawWebgl = ctx.getExtension("WEBGL_multi_draw"));
};
var _emscripten_webgl_enable_extension = function _emscripten_webgl_enable_extension(contextHandle, extension) {
  var context = GL.getContext(contextHandle);
  var extString = UTF8ToString(extension);
  if (extString.startsWith("GL_")) extString = extString.substr(3);
  if (extString == "ANGLE_instanced_arrays") webgl_enable_ANGLE_instanced_arrays(GLctx);
  if (extString == "OES_vertex_array_object") webgl_enable_OES_vertex_array_object(GLctx);
  if (extString == "WEBGL_draw_buffers") webgl_enable_WEBGL_draw_buffers(GLctx);
  if (extString == "WEBGL_draw_instanced_base_vertex_base_instance") webgl_enable_WEBGL_draw_instanced_base_vertex_base_instance(GLctx);
  if (extString == "WEBGL_multi_draw_instanced_base_vertex_base_instance") webgl_enable_WEBGL_multi_draw_instanced_base_vertex_base_instance(GLctx);
  if (extString == "WEBGL_multi_draw") webgl_enable_WEBGL_multi_draw(GLctx);
  var ext = context.GLctx.getExtension(extString);
  return !!ext;
};
var _emscripten_webgl_do_get_current_context = function _emscripten_webgl_do_get_current_context() {
  return GL.currentContext ? GL.currentContext.handle : 0;
};
var _emscripten_webgl_get_current_context = _emscripten_webgl_do_get_current_context;
var ENV = {};
var getExecutableName = function getExecutableName() {
  return thisProgram || "./this.program";
};
var getEnvStrings = function getEnvStrings() {
  if (!getEnvStrings.strings) {
    var lang = ((typeof navigator === "undefined" ? "undefined" : _typeof(navigator)) == "object" && navigator.languages && navigator.languages[0] || "C").replace("-", "_") + ".UTF-8";
    var env = {
      "USER": "web_user",
      "LOGNAME": "web_user",
      "PATH": "/",
      "PWD": "/",
      "HOME": "/home/web_user",
      "LANG": lang,
      "_": getExecutableName()
    };
    for (var x in ENV) {
      if (ENV[x] === undefined) delete env[x];else env[x] = ENV[x];
    }
    var strings = [];
    for (var x in env) {
      strings.push("".concat(x, "=").concat(env[x]));
    }
    getEnvStrings.strings = strings;
  }
  return getEnvStrings.strings;
};
var stringToAscii = function stringToAscii(str, buffer) {
  for (var i = 0; i < str.length; ++i) {
    HEAP8[buffer++] = str.charCodeAt(i);
  }
  HEAP8[buffer] = 0;
};
var _environ_get = function _environ_get(__environ, environ_buf) {
  var bufSize = 0;
  getEnvStrings().forEach(function (string, i) {
    var ptr = environ_buf + bufSize;
    HEAPU32[__environ + i * 4 >> 2] = ptr;
    stringToAscii(string, ptr);
    bufSize += string.length + 1;
  });
  return 0;
};
var _environ_sizes_get = function _environ_sizes_get(penviron_count, penviron_buf_size) {
  var strings = getEnvStrings();
  HEAPU32[penviron_count >> 2] = strings.length;
  var bufSize = 0;
  strings.forEach(function (string) {
    return bufSize += string.length + 1;
  });
  HEAPU32[penviron_buf_size >> 2] = bufSize;
  return 0;
};
function _fd_close(fd) {
  try {
    var stream = SYSCALLS.getStreamFromFD(fd);
    FS.close(stream);
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return e.errno;
  }
}
var doReadv = function doReadv(stream, iov, iovcnt, offset) {
  var ret = 0;
  for (var i = 0; i < iovcnt; i++) {
    var ptr = HEAPU32[iov >> 2];
    var len = HEAPU32[iov + 4 >> 2];
    iov += 8;
    var curr = FS.read(stream, HEAP8, ptr, len, offset);
    if (curr < 0) return -1;
    ret += curr;
    if (curr < len) break;
    if (typeof offset !== "undefined") {
      offset += curr;
    }
  }
  return ret;
};
function _fd_read(fd, iov, iovcnt, pnum) {
  try {
    var stream = SYSCALLS.getStreamFromFD(fd);
    var num = doReadv(stream, iov, iovcnt);
    HEAPU32[pnum >> 2] = num;
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return e.errno;
  }
}
function _fd_seek(fd, offset_low, offset_high, whence, newOffset) {
  var offset = convertI32PairToI53Checked(offset_low, offset_high);
  try {
    if (isNaN(offset)) return 61;
    var stream = SYSCALLS.getStreamFromFD(fd);
    FS.llseek(stream, offset, whence);
    tempI64 = [stream.position >>> 0, (tempDouble = stream.position, +Math.abs(tempDouble) >= 1 ? tempDouble > 0 ? +Math.floor(tempDouble / 4294967296) >>> 0 : ~~+Math.ceil((tempDouble - +(~~tempDouble >>> 0)) / 4294967296) >>> 0 : 0)], HEAP32[newOffset >> 2] = tempI64[0], HEAP32[newOffset + 4 >> 2] = tempI64[1];
    if (stream.getdents && offset === 0 && whence === 0) stream.getdents = null;
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return e.errno;
  }
}
var doWritev = function doWritev(stream, iov, iovcnt, offset) {
  var ret = 0;
  for (var i = 0; i < iovcnt; i++) {
    var ptr = HEAPU32[iov >> 2];
    var len = HEAPU32[iov + 4 >> 2];
    iov += 8;
    var curr = FS.write(stream, HEAP8, ptr, len, offset);
    if (curr < 0) return -1;
    ret += curr;
    if (typeof offset !== "undefined") {
      offset += curr;
    }
  }
  return ret;
};
function _fd_write(fd, iov, iovcnt, pnum) {
  try {
    var stream = SYSCALLS.getStreamFromFD(fd);
    var num = doWritev(stream, iov, iovcnt);
    HEAPU32[pnum >> 2] = num;
    return 0;
  } catch (e) {
    if (typeof FS == "undefined" || !(e.name === "ErrnoError")) throw e;
    return e.errno;
  }
}
var _getaddrinfo = function _getaddrinfo(node, service, hint, out) {
  var addr = 0;
  var port = 0;
  var flags = 0;
  var family = 0;
  var type = 0;
  var proto = 0;
  var ai;
  function allocaddrinfo(family, type, proto, canon, addr, port) {
    var sa, salen, ai;
    var errno;
    salen = family === 10 ? 28 : 16;
    addr = family === 10 ? inetNtop6(addr) : inetNtop4(addr);
    sa = _malloc(salen);
    errno = writeSockaddr(sa, family, addr, port);
    assert(!errno);
    ai = _malloc(32);
    HEAP32[ai + 4 >> 2] = family;
    HEAP32[ai + 8 >> 2] = type;
    HEAP32[ai + 12 >> 2] = proto;
    HEAPU32[ai + 24 >> 2] = canon;
    HEAPU32[ai + 20 >> 2] = sa;
    if (family === 10) {
      HEAP32[ai + 16 >> 2] = 28;
    } else {
      HEAP32[ai + 16 >> 2] = 16;
    }
    HEAP32[ai + 28 >> 2] = 0;
    return ai;
  }
  if (hint) {
    flags = HEAP32[hint >> 2];
    family = HEAP32[hint + 4 >> 2];
    type = HEAP32[hint + 8 >> 2];
    proto = HEAP32[hint + 12 >> 2];
  }
  if (type && !proto) {
    proto = type === 2 ? 17 : 6;
  }
  if (!type && proto) {
    type = proto === 17 ? 2 : 1;
  }
  if (proto === 0) {
    proto = 6;
  }
  if (type === 0) {
    type = 1;
  }
  if (!node && !service) {
    return -2;
  }
  if (flags & ~(1 | 2 | 4 | 1024 | 8 | 16 | 32)) {
    return -1;
  }
  if (hint !== 0 && HEAP32[hint >> 2] & 2 && !node) {
    return -1;
  }
  if (flags & 32) {
    return -2;
  }
  if (type !== 0 && type !== 1 && type !== 2) {
    return -7;
  }
  if (family !== 0 && family !== 2 && family !== 10) {
    return -6;
  }
  if (service) {
    service = UTF8ToString(service);
    port = parseInt(service, 10);
    if (isNaN(port)) {
      if (flags & 1024) {
        return -2;
      }
      return -8;
    }
  }
  if (!node) {
    if (family === 0) {
      family = 2;
    }
    if ((flags & 1) === 0) {
      if (family === 2) {
        addr = _htonl2(2130706433);
      } else {
        addr = [0, 0, 0, 1];
      }
    }
    ai = allocaddrinfo(family, type, proto, null, addr, port);
    HEAPU32[out >> 2] = ai;
    return 0;
  }
  node = UTF8ToString(node);
  addr = inetPton4(node);
  if (addr !== null) {
    if (family === 0 || family === 2) {
      family = 2;
    } else if (family === 10 && flags & 8) {
      addr = [0, 0, _htonl2(65535), addr];
      family = 10;
    } else {
      return -2;
    }
  } else {
    addr = inetPton6(node);
    if (addr !== null) {
      if (family === 0 || family === 10) {
        family = 10;
      } else {
        return -2;
      }
    }
  }
  if (addr != null) {
    ai = allocaddrinfo(family, type, proto, node, addr, port);
    HEAPU32[out >> 2] = ai;
    return 0;
  }
  if (flags & 4) {
    return -2;
  }
  node = DNS.lookup_name(node);
  addr = inetPton4(node);
  if (family === 0) {
    family = 2;
  } else if (family === 10) {
    addr = [0, 0, _htonl2(65535), addr];
  }
  ai = allocaddrinfo(family, type, proto, null, addr, port);
  HEAPU32[out >> 2] = ai;
  return 0;
};
var _getnameinfo = function _getnameinfo(sa, salen, node, nodelen, serv, servlen, flags) {
  var info = readSockaddr(sa, salen);
  if (info.errno) {
    return -6;
  }
  var port = info.port;
  var addr = info.addr;
  var overflowed = false;
  if (node && nodelen) {
    var lookup;
    if (flags & 1 || !(lookup = DNS.lookup_addr(addr))) {
      if (flags & 8) {
        return -2;
      }
    } else {
      addr = lookup;
    }
    var numBytesWrittenExclNull = stringToUTF8(addr, node, nodelen);
    if (numBytesWrittenExclNull + 1 >= nodelen) {
      overflowed = true;
    }
  }
  if (serv && servlen) {
    port = "" + port;
    var numBytesWrittenExclNull = stringToUTF8(port, serv, servlen);
    if (numBytesWrittenExclNull + 1 >= servlen) {
      overflowed = true;
    }
  }
  if (overflowed) {
    return -12;
  }
  return 0;
};
var GLFW = {
  keyFunc: null,
  charFunc: null,
  markedTextFunc: null,
  gamepadFunc: null,
  mouseButtonFunc: null,
  mousePosFunc: null,
  mouseWheelFunc: null,
  resizeFunc: null,
  closeFunc: null,
  refreshFunc: null,
  focusFunc: null,
  iconifyFunc: null,
  touchFunc: null,
  params: null,
  initTime: null,
  wheelPos: 0,
  buttons: 0,
  keys: 0,
  initWindowWidth: 640,
  initWindowHeight: 480,
  windowX: 0,
  windowY: 0,
  windowWidth: 0,
  windowHeight: 0,
  prevWidth: 0,
  prevHeight: 0,
  prevNonFSWidth: 0,
  prevNonFSHeight: 0,
  isFullscreen: false,
  isPointerLocked: false,
  dpi: 1,
  mouseTouchId: null,
  DOMToGLFWKeyCode: function DOMToGLFWKeyCode(keycode, code) {
    switch (keycode) {
      case 8:
        return 295;
      case 9:
        return 293;
      case 13:
        return 294;
      case 27:
        return 257;
      case 106:
        return 313;
      case 107:
        return 315;
      case 109:
        return 314;
      case 110:
        return 316;
      case 111:
        return 312;
      case 112:
        return 258;
      case 113:
        return 259;
      case 114:
        return 260;
      case 115:
        return 261;
      case 116:
        return 262;
      case 117:
        return 263;
      case 118:
        return 264;
      case 119:
        return 265;
      case 120:
        return 266;
      case 121:
        return 267;
      case 122:
        return 268;
      case 123:
        return 269;
      case 37:
        return 285;
      case 38:
        return 283;
      case 39:
        return 286;
      case 40:
        return 284;
      case 33:
        return 298;
      case 34:
        return 299;
      case 36:
        return 300;
      case 35:
        return 301;
      case 45:
        return 296;
      case 16:
        return 287;
      case 5:
        return 287;
      case 6:
        return 288;
      case 17:
        return 289;
      case 3:
        return 289;
      case 4:
        return 290;
      case 18:
        return 291;
      case 2:
        return 291;
      case 1:
        return 292;
      case 96:
        return 302;
      case 97:
        return 303;
      case 98:
        return 304;
      case 99:
        return 305;
      case 100:
        return 306;
      case 101:
        return 307;
      case 102:
        return 308;
      case 103:
        return 309;
      case 104:
        return 310;
      case 105:
        return 311;
    }
    switch (code) {
      case "Minus":
        return 45;
      case "Period":
        return 46;
      case "Comma":
        return 44;
      case "Slash":
        return 47;
      case "Backslash":
        return 92;
      case "IntlRo":
        return 92;
      case "IntlYen":
        return 92;
      case "IntlBackslash":
        return 92;
      case "Backquote":
        return 96;
      case "BracketLeft":
        return 91;
      case "BracketRight":
        return 93;
      case "Equal":
        return 61;
      case "Quote":
        return 39;
      case "Semicolon":
        return 59;
      case "NumpadComma":
        return 316;
    }
    return keycode;
  },
  DOMtoGLFWButton: function DOMtoGLFWButton(button) {
    if (button == 1) {
      button = 2;
    } else if (button == 2) {
      button = 1;
    }
    return button;
  },
  getUnicodeChar: function getUnicodeChar(value) {
    var output = "";
    if (value > 65535) {
      value -= 65536;
      output += String.fromCharCode(value >>> 10 & 1023 | 55296);
      value = 56320 | value & 1023;
    }
    output += String.fromCharCode(value);
    return output;
  },
  addEventListener: function addEventListener(type, listener, useCapture) {
    if (typeof window !== "undefined") {
      window.addEventListener(type, listener, useCapture);
    }
  },
  removeEventListener: function removeEventListener(type, listener, useCapture) {
    if (typeof window !== "undefined") {
      window.removeEventListener(type, listener, useCapture);
    }
  },
  addEventListenerCanvas: function addEventListenerCanvas(type, listener, useCapture) {
    if (typeof Module["canvas"] !== "undefined") {
      Module["canvas"].addEventListener(type, listener, useCapture);
    }
  },
  removeEventListenerCanvas: function removeEventListenerCanvas(type, listener, useCapture) {
    if (typeof Module["canvas"] !== "undefined") {
      Module["canvas"].removeEventListener(type, listener, useCapture);
    }
  },
  isCanvasActive: function isCanvasActive(event) {
    var res = typeof document.activeElement == "undefined" || document.activeElement == Module["canvas"];
    if (!res) {
      res = event.target == Module["canvas"];
    }
    if (event.target.focus) event.target.focus();
    return res;
  },
  onKeyPress: function onKeyPress(event) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    if (event.charCode) {
      var char = GLFW.getUnicodeChar(event.charCode);
      if (char !== null && GLFW.charFunc) {
        getWasmTableEntry(GLFW.charFunc)(event.charCode, 1);
      }
    }
  },
  onKeyChanged: function onKeyChanged(event, status) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    var key = GLFW.DOMToGLFWKeyCode(event.keyCode, event.code);
    if (key) {
      GLFW.keys[key] = status;
      if (GLFW.keyFunc) {
        getWasmTableEntry(GLFW.keyFunc)(key, status);
      }
    }
  },
  onKeydown: function onKeydown(event) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    switch (event.keyCode) {
      case 37:
      case 38:
      case 39:
      case 40:
      case 32:
        event.preventDefault();
        event.stopPropagation();
      default:
        break;
    }
    GLFW.onKeyChanged(event, 1);
    if (event.keyCode === 32) {
      if (GLFW.charFunc) {
        getWasmTableEntry(GLFW.charFunc)(32, 1);
        event.preventDefault();
      }
    } else if (event.keyCode === 8 || event.keyCode === 9 || event.keyCode === 13) {
      event.preventDefault();
    }
  },
  onKeyup: function onKeyup(event) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    GLFW.onKeyChanged(event, 0);
  },
  onMousemove: function onMousemove(event) {
    var lastX = Browser.mouseX;
    var lastY = Browser.mouseY;
    Browser.calculateMouseEvent(event);
    var newX = Browser.mouseX;
    var newY = Browser.mouseY;
    if (event.target == Module["canvas"] && GLFW.mousePosFunc) {
      event.preventDefault();
      getWasmTableEntry(GLFW.mousePosFunc)(lastX, lastY);
    }
  },
  onMouseButtonChanged: function onMouseButtonChanged(event, status) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    if (GLFW.mouseButtonFunc == null) {
      return;
    }
    Browser.calculateMouseEvent(event);
    if (event.target != Module["canvas"]) {
      return;
    }
    if (status == 1) {
      try {
        event.target.setCapture();
      } catch (e) {}
    }
    event.preventDefault();
    var eventButton = GLFW.DOMtoGLFWButton(event["button"]);
    getWasmTableEntry(GLFW.mouseButtonFunc)(eventButton, status);
  },
  fillTouch: function fillTouch(id, x, y, phase) {
    if (GLFW.touchFunc) {
      getWasmTableEntry(GLFW.touchFunc)(id, x, y, phase);
    }
  },
  touchWasFinished: function touchWasFinished(event, phase) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    for (var i = 0; i < event.changedTouches.length; ++i) {
      var touch = event.changedTouches[i];
      var coord = GLFW.convertCoordinatesFromMonitorToWebGLPixels(touch.clientX, touch.clientY);
      var canvasX = coord[0];
      var canvasY = coord[1];
      GLFW.fillTouch(touch.identifier, canvasX, canvasY, phase);
      if (touch.identifier == GLFW.mouseTouchId) {
        GLFW.mouseTouchId = null;
        GLFW.buttons &= ~(1 << 0);
      }
    }
    if (event.touches.length == 0) {
      GLFW.buttons &= ~(1 << 0);
    }
    if (typeof DefoldSoundDevice != "undefined" && DefoldSoundDevice != null) {
      DefoldSoundDevice.TryResumeAudio();
    }
    event.preventDefault();
  },
  onTouchEnd: function onTouchEnd(event) {
    GLFW.touchWasFinished(event, GLFW.GLFW_PHASE_ENDED);
  },
  onTouchCancel: function onTouchCancel(event) {
    GLFW.touchWasFinished(event, GLFW.GLFW_PHASE_CANCELLED);
  },
  convertCoordinatesFromMonitorToWebGLPixels: function convertCoordinatesFromMonitorToWebGLPixels(x, y) {
    var rect = Module["canvas"].getBoundingClientRect();
    var canvasWidth = rect.right - rect.left;
    var canvasHeight = rect.bottom - rect.top;
    var canvasX = x - rect.left;
    var canvasY = y - rect.top;
    var canvasXNormalized = canvasX / canvasWidth;
    var canvasYNormalized = canvasY / canvasHeight;
    var finalX = Module["canvas"].width * canvasXNormalized;
    var finalY = Module["canvas"].height * canvasYNormalized;
    return [finalX, finalY];
  },
  onTouchMove: function onTouchMove(event) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    var e = event;
    var touch;
    var coord;
    var canvasX;
    var canvasY;
    for (var i = 0; i < e.changedTouches.length; ++i) {
      touch = e.changedTouches[i];
      coord = GLFW.convertCoordinatesFromMonitorToWebGLPixels(touch.clientX, touch.clientY);
      canvasX = coord[0];
      canvasY = coord[1];
      if (touch.identifier == GLFW.mouseTouchId) {
        Browser.mouseX = canvasX;
        Browser.mouseY = canvasY;
      }
      GLFW.fillTouch(touch.identifier, canvasX, canvasY, GLFW.GLFW_PHASE_MOVED);
    }
    event.preventDefault();
  },
  onTouchStart: function onTouchStart(event) {
    if (event.target != Module["canvas"]) {
      return;
    }
    var e = event;
    var touch;
    var coord;
    var canvasX;
    var canvasY;
    for (var i = 0; i < e.changedTouches.length; ++i) {
      touch = e.changedTouches[i];
      coord = GLFW.convertCoordinatesFromMonitorToWebGLPixels(touch.clientX, touch.clientY);
      canvasX = coord[0];
      canvasY = coord[1];
      if (i == 0 && GLFW.mouseTouchId == null) {
        GLFW.mouseTouchId = touch.identifier;
        GLFW.buttons |= 1 << 0;
        Browser.mouseX = canvasX;
        Browser.mouseY = canvasY;
      }
      GLFW.fillTouch(touch.identifier, canvasX, canvasY, GLFW.GLFW_PHASE_BEGAN);
    }
    event.preventDefault();
  },
  onMouseButtonDown: function onMouseButtonDown(event) {
    if (event.target != Module["canvas"]) {
      return;
    }
    GLFW.buttons |= 1 << event["button"];
    GLFW.onMouseButtonChanged(event, 1);
  },
  onMouseButtonUp: function onMouseButtonUp(event) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    GLFW.buttons &= ~(1 << event["button"]);
    GLFW.onMouseButtonChanged(event, 0);
    if (typeof DefoldSoundDevice != "undefined" && DefoldSoundDevice != null) {
      DefoldSoundDevice.TryResumeAudio();
    }
  },
  onMouseWheel: function onMouseWheel(event) {
    if (!GLFW.isCanvasActive(event)) {
      return;
    }
    GLFW.wheelPos += Browser.getMouseWheelDelta(event);
    if (event.target == Module["canvas"]) {
      if (GLFW.mouseWheelFunc) {
        getWasmTableEntry(GLFW.mouseWheelFunc)(GLFW.wheelPos);
      }
      if (event.cancelable) {
        event.preventDefault();
      }
    }
  },
  onFocusChanged: function onFocusChanged(focus) {
    if (focus == 0) {
      for (var i = 0; i < GLFW.keys.length; i++) {
        GLFW.keys[i] = 0;
      }
      GLFW.buttons = 0;
    }
    if (GLFW.focusFunc) {
      getWasmTableEntry(GLFW.focusFunc)(focus);
    }
  },
  onFocus: function onFocus(event) {
    GLFW.onFocusChanged(1);
  },
  onBlur: function onBlur(event) {
    GLFW.onFocusChanged(0);
  },
  onFullScreenEventChange: function onFullScreenEventChange(event) {
    GLFW.isFullscreen = document["fullScreen"] || document["mozFullScreen"] || document["webkitIsFullScreen"] || document["msIsFullScreen"];
    if (!GLFW.isFullscreen) {
      document.removeEventListener("fullscreenchange", GLFW.onFullScreenEventChange, true);
      document.removeEventListener("mozfullscreenchange", GLFW.onFullScreenEventChange, true);
      document.removeEventListener("webkitfullscreenchange", GLFW.onFullScreenEventChange, true);
      document.removeEventListener("msfullscreenchange", GLFW.onFullScreenEventChange, true);
    }
    GLFW.prevWidth = 0;
    GLFW.prevHeight = 0;
  },
  requestFullScreen: function requestFullScreen(element) {
    element = element || Module["fullScreenContainer"] || Module["canvas"];
    if (!element) {
      return;
    }
    document.addEventListener("fullscreenchange", GLFW.onFullScreenEventChange, true);
    document.addEventListener("mozfullscreenchange", GLFW.onFullScreenEventChange, true);
    document.addEventListener("webkitfullscreenchange", GLFW.onFullScreenEventChange, true);
    document.addEventListener("msfullscreenchange", GLFW.onFullScreenEventChange, true);
    var RFS = element["requestFullscreen"] || element["requestFullScreen"] || element["mozRequestFullScreen"] || element["webkitRequestFullScreen"] || element["msRequestFullScreen"] || function () {};
    RFS.apply(element, []);
  },
  cancelFullScreen: function cancelFullScreen() {
    var CFS = document["exitFullscreen"] || document["cancelFullScreen"] || document["mozCancelFullScreen"] || document["webkitCancelFullScreen"] || document["msExitFullscreen"] || function () {};
    CFS.apply(document, []);
  },
  onJoystickConnected: function onJoystickConnected(event) {
    GLFW.refreshJoysticks();
  },
  onJoystickDisconnected: function onJoystickDisconnected(event) {
    GLFW.refreshJoysticks(true);
  },
  onPointerLockEventChange: function onPointerLockEventChange(event) {
    GLFW.isPointerLocked = !!document["pointerLockElement"];
    if (!GLFW.isPointerLocked) {
      document.removeEventListener("pointerlockchange", GLFW.onPointerLockEventChange, true);
    }
  },
  requestPointerLock: function requestPointerLock(element) {
    element = element || Module["canvas"];
    if (!element) {
      return;
    }
    if (!GLFW.isPointerLocked) {
      document.addEventListener("pointerlockchange", GLFW.onPointerLockEventChange, true);
      var RPL = element.requestPointerLock || function () {};
      RPL.apply(element, []);
    }
  },
  cancelPointerLock: function cancelPointerLock() {
    var EPL = document.exitPointerLock || function () {};
    EPL.apply(document, []);
  },
  disconnectJoystick: function disconnectJoystick(joy) {
    if (GLFW.gamepadFunc) {
      _free(GLFW.joys[joy].id);
      delete GLFW.joys[joy];
      getWasmTableEntry(GLFW.gamepadFunc)(joy, 0);
    }
  },
  joys: {},
  lastGamepadState: null,
  lastGamepadStateFrame: null,
  refreshJoysticks: function refreshJoysticks(forceUpdate) {
    if (GLFW.gamepadFunc) {
      if (forceUpdate || Browser.mainLoop.currentFrameNumber !== GLFW.lastGamepadStateFrame || !Browser.mainLoop.currentFrameNumber) {
        GLFW.lastGamepadState = navigator.getGamepads ? navigator.getGamepads() : navigator.webkitGetGamepads ? navigator.webkitGetGamepads : null;
        if (!GLFW.lastGamepadState) {
          return;
        }
        GLFW.lastGamepadStateFrame = Browser.mainLoop.currentFrameNumber;
        for (var joy = 0; joy < GLFW.lastGamepadState.length; ++joy) {
          var gamepad = GLFW.lastGamepadState[joy];
          if (gamepad) {
            var gamepad_id = gamepad.mapping == "standard" ? "Standard Gamepad" : gamepad.id;
            if (!GLFW.joys[joy] || GLFW.joys[joy].id_string != gamepad_id) {
              if (GLFW.joys[joy]) {
                GLFW.disconnectJoystick(joy);
              }
              GLFW.joys[joy] = {
                id: stringToNewUTF8(gamepad_id),
                id_string: gamepad_id,
                axesCount: gamepad.axes.length,
                buttonsCount: gamepad.buttons.length
              };
              getWasmTableEntry(GLFW.gamepadFunc)(joy, 1);
            }
            GLFW.joys[joy].buttons = gamepad.buttons;
            GLFW.joys[joy].axes = gamepad.axes;
          } else {
            if (GLFW.joys[joy]) {
              GLFW.disconnectJoystick(joy);
            }
          }
        }
      }
    }
  }
};
function _glfwAccelerometerEnable() {}
function _glfwCloseWindow() {
  if (GLFW.closeFunc) {
    getWasmTableEntry(GLFW.closeFunc)();
  }
  Module.ctx = Browser.destroyContext(Module["canvas"], true, true);
}
function _glfwDisable(token) {
  GLFW.params[token] = false;
  if (token == 196609) {
    GLFW.requestPointerLock();
  }
}
function _glfwEnable(token) {
  GLFW.params[token] = true;
  if (token == 196609) {
    GLFW.cancelPointerLock();
  }
}
function _glfwGetAcceleration(x, y, z) {
  return 0;
}
function _glfwGetDefaultFramebuffer() {
  return 0;
}
function _glfwGetDisplayScaleFactor() {
  return 1;
}
function _glfwGetJoystickButtons(joy, buttons, numbuttons) {
  GLFW.refreshJoysticks();
  var state = GLFW.joys[joy];
  if (!state || !state.buttons) {
    for (var i = 0; i < numbuttons; i++) {
      setValue(buttons + i, 0, "i8");
    }
    return;
  }
  for (var i = 0; i < Math.min(numbuttons, state.buttonsCount); i++) {
    setValue(buttons + i, state.buttons[i].pressed, "i8");
  }
}
function _glfwGetJoystickDeviceId(joy, device_id) {
  if (GLFW.joys[joy]) {
    setValue(device_id, GLFW.joys[joy].id, "*");
    return 1;
  } else {
    return 0;
  }
}
function _glfwGetJoystickHats(joy, buttons, numhats) {
  return 0;
}
function _glfwGetJoystickParam(joy, param) {
  var result = 0;
  if (GLFW.joys[joy]) {
    switch (GLFW.params[param]) {
      case 0:
        result = 1;
        break;
      case 1:
        result = GLFW.joys[joy].axesCount;
        break;
      case 2:
        result = GLFW.joys[joy].buttonsCount;
        break;
    }
  }
  return result;
}
function _glfwGetJoystickPos(joy, pos, numaxes) {
  GLFW.refreshJoysticks();
  var state = GLFW.joys[joy];
  if (!state || !state.axes) {
    for (var i = 0; i < numaxes; i++) {
      setValue(pos + i * 4, 0, "float");
    }
    return;
  }
  for (var i = 0; i < numaxes; i++) {
    setValue(pos + i * 4, state.axes[i], "float");
  }
}
function _glfwGetKey(key) {
  return GLFW.keys[key];
}
function _glfwGetMouseButton(button) {
  return (GLFW.buttons & 1 << GLFW.DOMtoGLFWButton(button)) > 0;
}
function _glfwGetMouseLocked() {
  return GLFW.isPointerLocked ? 1 : 0;
}
function _glfwGetMousePos(xpos, ypos) {
  setValue(xpos, Browser.mouseX, "i32");
  setValue(ypos, Browser.mouseY, "i32");
}
function _glfwGetMouseWheel() {
  return GLFW.wheelPos;
}
function _glfwGetWindowParam(param) {
  return GLFW.params[param];
}
function _glfwGetWindowRefreshRate() {
  return 0;
}
function _glfwGetWindowSize(width, height) {
  setValue(width, Module["canvas"].width, "i32");
  setValue(height, Module["canvas"].height, "i32");
}
function _glfwIconifyWindow() {}
function _glfwInitJS() {
  GLFW.initTime = Date.now() / 1e3;
  GLFW.addEventListener("gamepadconnected", GLFW.onJoystickConnected, true);
  GLFW.addEventListener("gamepaddisconnected", GLFW.onJoystickDisconnected, true);
  GLFW.addEventListener("keydown", GLFW.onKeydown, true);
  GLFW.addEventListener("keypress", GLFW.onKeyPress, true);
  GLFW.addEventListener("keyup", GLFW.onKeyup, true);
  GLFW.addEventListener("mousemove", GLFW.onMousemove, true);
  GLFW.addEventListener("mousedown", GLFW.onMouseButtonDown, true);
  GLFW.addEventListener("mouseup", GLFW.onMouseButtonUp, true);
  GLFW.addEventListener("DOMMouseScroll", GLFW.onMouseWheel, {
    capture: true,
    passive: false
  });
  GLFW.addEventListener("mousewheel", GLFW.onMouseWheel, {
    capture: true,
    passive: false
  });
  GLFW.addEventListenerCanvas("touchstart", GLFW.onTouchStart, true);
  GLFW.addEventListenerCanvas("touchend", GLFW.onTouchEnd, true);
  GLFW.addEventListenerCanvas("touchcancel", GLFW.onTouchCancel, true);
  GLFW.addEventListenerCanvas("touchmove", GLFW.onTouchMove, true);
  GLFW.addEventListenerCanvas("focus", GLFW.onFocus, true);
  GLFW.addEventListenerCanvas("blur", GLFW.onBlur, true);
  __ATEXIT__.push({
    func: function func() {
      GLFW.removeEventListener("gamepadconnected", GLFW.onJoystickConnected, true);
      GLFW.removeEventListener("gamepaddisconnected", GLFW.onJoystickDisconnected, true);
      GLFW.removeEventListener("keydown", GLFW.onKeydown, true);
      GLFW.removeEventListener("keypress", GLFW.onKeyPress, true);
      GLFW.removeEventListener("keyup", GLFW.onKeyup, true);
      GLFW.removeEventListener("mousemove", GLFW.onMousemove, true);
      GLFW.removeEventListener("mousedown", GLFW.onMouseButtonDown, true);
      GLFW.removeEventListener("mouseup", GLFW.onMouseButtonUp, true);
      GLFW.removeEventListener("DOMMouseScroll", GLFW.onMouseWheel, {
        capture: true,
        passive: false
      });
      GLFW.removeEventListener("mousewheel", GLFW.onMouseWheel, {
        capture: true,
        passive: false
      });
      GLFW.removeEventListenerCanvas("touchstart", GLFW.onTouchStart, true);
      GLFW.removeEventListenerCanvas("touchend", GLFW.onTouchEnd, true);
      GLFW.removeEventListenerCanvas("touchcancel", GLFW.onTouchEnd, true);
      GLFW.removeEventListenerCanvas("touchmove", GLFW.onTouchMove, true);
      GLFW.removeEventListenerCanvas("focus", GLFW.onFocus, true);
      GLFW.removeEventListenerCanvas("blur", GLFW.onBlur, true);
      var canvas = Module["canvas"];
      if (typeof canvas !== "undefined") {
        Module["canvas"].width = Module["canvas"].height = 1;
      }
    }
  });
  GLFW.params = new Array();
  GLFW.params[196609] = true;
  GLFW.params[196610] = false;
  GLFW.params[196611] = true;
  GLFW.params[196612] = false;
  GLFW.params[196613] = false;
  GLFW.params[196614] = true;
  GLFW.params[131073] = true;
  GLFW.params[131074] = true;
  GLFW.params[131075] = false;
  GLFW.params[131076] = true;
  GLFW.params[131077] = 0;
  GLFW.params[131078] = 0;
  GLFW.params[131079] = 0;
  GLFW.params[131080] = 0;
  GLFW.params[131081] = 0;
  GLFW.params[131082] = 0;
  GLFW.params[131083] = 0;
  GLFW.params[131084] = 0;
  GLFW.params[131085] = 0;
  GLFW.params[131086] = 0;
  GLFW.params[131087] = 0;
  GLFW.params[131088] = 0;
  GLFW.params[131089] = 0;
  GLFW.params[131090] = 0;
  GLFW.params[131091] = 0;
  GLFW.params[131092] = 0;
  GLFW.params[131093] = 0;
  GLFW.params[131094] = 0;
  GLFW.params[131095] = 0;
  GLFW.params[131096] = 0;
  GLFW.params[327681] = 0;
  GLFW.params[327682] = 1;
  GLFW.params[327683] = 2;
  GLFW.params[131097] = 0;
  GLFW.keys = new Array();
  GLFW.GLFW_PHASE_BEGAN = 0;
  GLFW.GLFW_PHASE_MOVED = 1;
  GLFW.GLFW_PHASE_ENDED = 3;
  GLFW.GLFW_PHASE_CANCELLED = 4;
  return 1;
}
function _glfwOpenWindow(width, height, redbits, greenbits, bluebits, alphabits, depthbits, stencilbits, mode) {
  if (width == 0 && height > 0) {
    width = 4 * height / 3;
  }
  if (width > 0 && height == 0) {
    height = 3 * width / 4;
  }
  GLFW.params[131077] = redbits;
  GLFW.params[131078] = greenbits;
  GLFW.params[131079] = bluebits;
  GLFW.params[131080] = alphabits;
  GLFW.params[131081] = depthbits;
  GLFW.params[131082] = stencilbits;
  if (mode == 65537) {
    GLFW.initWindowWidth = width;
    GLFW.initWindowHeight = height;
    GLFW.params[196611] = true;
  } else if (mode == 65538) {
    GLFW.requestFullScreen();
    GLFW.params[196611] = false;
  } else {
    throw "Invalid glfwOpenWindow mode.";
  }
  var contextAttributes = {
    antialias: GLFW.params[131091] > 1,
    depth: GLFW.params[131081] > 0,
    stencil: GLFW.params[131082] > 0
  };
  var iOSVersion = false;
  try {
    iOSVersion = parseFloat(("" + (/CPU.*OS ([0-9_]{1,5})|(CPU like).*AppleWebKit.*Mobile/i.exec(navigator.userAgent) || [0, ""])[1]).replace("undefined", "3_2").replace("_", ".").replace("_", "")) || false;
  } catch (e) {}
  if (iOSVersion && iOSVersion < 15.2) {
    contextAttributes.majorVersion = 1;
  }
  Module.ctx = Browser.createContext(Module["canvas"], true, true, contextAttributes);
  if (Module.ctx == null) {
    contextAttributes.majorVersion = 1;
    Module.ctx = Browser.createContext(Module["canvas"], true, true, contextAttributes);
  }
  return 1;
}
function _glfwOpenWindowHint(target, hint) {
  GLFW.params[target] = hint;
  if (target == 131097) {
    if (hint != 0) {
      GLFW.dpi = window.devicePixelRatio || 1;
    }
  }
}
function _glfwPollEvents() {}
function _glfwResetKeyboard() {}
function _glfwSetCharCallback(cbfun) {
  GLFW.charFunc = cbfun;
  return 1;
}
function _glfwSetDeviceChangedCallback(cbfun) {
  return 1;
}
function _glfwSetGamepadCallback(cbfun) {
  GLFW.gamepadFunc = cbfun;
  try {
    GLFW.refreshJoysticks();
    return 1;
  } catch (e) {
    GLFW.gamepadFunc = null;
    return 0;
  }
}
function _glfwSetMarkedTextCallback(cbfun) {
  GLFW.markedTextFunc = cbfun;
  return 1;
}
function _glfwSetTouchCallback(cbfun) {
  GLFW.touchFunc = cbfun;
  return 1;
}
function _glfwSetWindowBackgroundColor() {}
function _glfwSetWindowCloseCallback(cbfun) {
  GLFW.closeFunc = cbfun;
}
function _glfwSetWindowFocusCallback(cbfun) {
  GLFW.focusFunc = cbfun;
}
function _glfwSetWindowIconifyCallback(cbfun) {
  GLFW.iconifyFunc = cbfun;
}
function _glfwSetWindowSize(width, height) {
  Browser.setCanvasSize(width, height);
  if (GLFW.resizeFunc) {
    getWasmTableEntry(GLFW.resizeFunc)(width, height);
  }
}
function _glfwSetWindowSizeCallback(cbfun) {
  GLFW.resizeFunc = cbfun;
}
function _glfwShowKeyboard(show_keyboard) {
  Module["canvas"].contentEditable = show_keyboard ? true : false;
  if (show_keyboard) {
    Module["canvas"].focus();
  }
}
function _glfwSwapBuffers() {
  var width = Module["canvas"].width;
  var height = Module["canvas"].height;
  if (GLFW.prevWidth != width || GLFW.prevHeight != height) {
    if (GLFW.isFullscreen) {
      width = Math.floor(window.innerWidth * GLFW.dpi);
      height = Math.floor(window.innerHeight * GLFW.dpi);
    }
    GLFW.prevWidth = width;
    GLFW.prevHeight = height;
    _glfwSetWindowSize(width, height);
  }
}
function _glfwSwapInterval(interval) {}
function _glfwTerminate() {}
var arraySum = function arraySum(array, index) {
  var sum = 0;
  for (var i = 0; i <= index; sum += array[i++]) {}
  return sum;
};
var MONTH_DAYS_LEAP = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
var MONTH_DAYS_REGULAR = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
var addDays = function addDays(date, days) {
  var newDate = new Date(date.getTime());
  while (days > 0) {
    var leap = isLeapYear(newDate.getFullYear());
    var currentMonth = newDate.getMonth();
    var daysInCurrentMonth = (leap ? MONTH_DAYS_LEAP : MONTH_DAYS_REGULAR)[currentMonth];
    if (days > daysInCurrentMonth - newDate.getDate()) {
      days -= daysInCurrentMonth - newDate.getDate() + 1;
      newDate.setDate(1);
      if (currentMonth < 11) {
        newDate.setMonth(currentMonth + 1);
      } else {
        newDate.setMonth(0);
        newDate.setFullYear(newDate.getFullYear() + 1);
      }
    } else {
      newDate.setDate(newDate.getDate() + days);
      return newDate;
    }
  }
  return newDate;
};
var writeArrayToMemory = function writeArrayToMemory(array, buffer) {
  HEAP8.set(array, buffer);
};
var _strftime = function _strftime(s, maxsize, format, tm) {
  var tm_zone = HEAPU32[tm + 40 >> 2];
  var date = {
    tm_sec: HEAP32[tm >> 2],
    tm_min: HEAP32[tm + 4 >> 2],
    tm_hour: HEAP32[tm + 8 >> 2],
    tm_mday: HEAP32[tm + 12 >> 2],
    tm_mon: HEAP32[tm + 16 >> 2],
    tm_year: HEAP32[tm + 20 >> 2],
    tm_wday: HEAP32[tm + 24 >> 2],
    tm_yday: HEAP32[tm + 28 >> 2],
    tm_isdst: HEAP32[tm + 32 >> 2],
    tm_gmtoff: HEAP32[tm + 36 >> 2],
    tm_zone: tm_zone ? UTF8ToString(tm_zone) : ""
  };
  var pattern = UTF8ToString(format);
  var EXPANSION_RULES_1 = {
    "%c": "%a %b %d %H:%M:%S %Y",
    "%D": "%m/%d/%y",
    "%F": "%Y-%m-%d",
    "%h": "%b",
    "%r": "%I:%M:%S %p",
    "%R": "%H:%M",
    "%T": "%H:%M:%S",
    "%x": "%m/%d/%y",
    "%X": "%H:%M:%S",
    "%Ec": "%c",
    "%EC": "%C",
    "%Ex": "%m/%d/%y",
    "%EX": "%H:%M:%S",
    "%Ey": "%y",
    "%EY": "%Y",
    "%Od": "%d",
    "%Oe": "%e",
    "%OH": "%H",
    "%OI": "%I",
    "%Om": "%m",
    "%OM": "%M",
    "%OS": "%S",
    "%Ou": "%u",
    "%OU": "%U",
    "%OV": "%V",
    "%Ow": "%w",
    "%OW": "%W",
    "%Oy": "%y"
  };
  for (var rule in EXPANSION_RULES_1) {
    pattern = pattern.replace(new RegExp(rule, "g"), EXPANSION_RULES_1[rule]);
  }
  var WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  var MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
  function leadingSomething(value, digits, character) {
    var str = typeof value == "number" ? value.toString() : value || "";
    while (str.length < digits) {
      str = character[0] + str;
    }
    return str;
  }
  function leadingNulls(value, digits) {
    return leadingSomething(value, digits, "0");
  }
  function compareByDay(date1, date2) {
    function sgn(value) {
      return value < 0 ? -1 : value > 0 ? 1 : 0;
    }
    var compare;
    if ((compare = sgn(date1.getFullYear() - date2.getFullYear())) === 0) {
      if ((compare = sgn(date1.getMonth() - date2.getMonth())) === 0) {
        compare = sgn(date1.getDate() - date2.getDate());
      }
    }
    return compare;
  }
  function getFirstWeekStartDate(janFourth) {
    switch (janFourth.getDay()) {
      case 0:
        return new Date(janFourth.getFullYear() - 1, 11, 29);
      case 1:
        return janFourth;
      case 2:
        return new Date(janFourth.getFullYear(), 0, 3);
      case 3:
        return new Date(janFourth.getFullYear(), 0, 2);
      case 4:
        return new Date(janFourth.getFullYear(), 0, 1);
      case 5:
        return new Date(janFourth.getFullYear() - 1, 11, 31);
      case 6:
        return new Date(janFourth.getFullYear() - 1, 11, 30);
    }
  }
  function getWeekBasedYear(date) {
    var thisDate = addDays(new Date(date.tm_year + 1900, 0, 1), date.tm_yday);
    var janFourthThisYear = new Date(thisDate.getFullYear(), 0, 4);
    var janFourthNextYear = new Date(thisDate.getFullYear() + 1, 0, 4);
    var firstWeekStartThisYear = getFirstWeekStartDate(janFourthThisYear);
    var firstWeekStartNextYear = getFirstWeekStartDate(janFourthNextYear);
    if (compareByDay(firstWeekStartThisYear, thisDate) <= 0) {
      if (compareByDay(firstWeekStartNextYear, thisDate) <= 0) {
        return thisDate.getFullYear() + 1;
      }
      return thisDate.getFullYear();
    }
    return thisDate.getFullYear() - 1;
  }
  var EXPANSION_RULES_2 = {
    "%a": function a(date) {
      return WEEKDAYS[date.tm_wday].substring(0, 3);
    },
    "%A": function A(date) {
      return WEEKDAYS[date.tm_wday];
    },
    "%b": function b(date) {
      return MONTHS[date.tm_mon].substring(0, 3);
    },
    "%B": function B(date) {
      return MONTHS[date.tm_mon];
    },
    "%C": function C(date) {
      var year = date.tm_year + 1900;
      return leadingNulls(year / 100 | 0, 2);
    },
    "%d": function d(date) {
      return leadingNulls(date.tm_mday, 2);
    },
    "%e": function e(date) {
      return leadingSomething(date.tm_mday, 2, " ");
    },
    "%g": function g(date) {
      return getWeekBasedYear(date).toString().substring(2);
    },
    "%G": getWeekBasedYear,
    "%H": function H(date) {
      return leadingNulls(date.tm_hour, 2);
    },
    "%I": function I(date) {
      var twelveHour = date.tm_hour;
      if (twelveHour == 0) twelveHour = 12;else if (twelveHour > 12) twelveHour -= 12;
      return leadingNulls(twelveHour, 2);
    },
    "%j": function j(date) {
      return leadingNulls(date.tm_mday + arraySum(isLeapYear(date.tm_year + 1900) ? MONTH_DAYS_LEAP : MONTH_DAYS_REGULAR, date.tm_mon - 1), 3);
    },
    "%m": function m(date) {
      return leadingNulls(date.tm_mon + 1, 2);
    },
    "%M": function M(date) {
      return leadingNulls(date.tm_min, 2);
    },
    "%n": function n() {
      return "\n";
    },
    "%p": function p(date) {
      if (date.tm_hour >= 0 && date.tm_hour < 12) {
        return "AM";
      }
      return "PM";
    },
    "%S": function S(date) {
      return leadingNulls(date.tm_sec, 2);
    },
    "%t": function t() {
      return "\t";
    },
    "%u": function u(date) {
      return date.tm_wday || 7;
    },
    "%U": function U(date) {
      var days = date.tm_yday + 7 - date.tm_wday;
      return leadingNulls(Math.floor(days / 7), 2);
    },
    "%V": function V(date) {
      var val = Math.floor((date.tm_yday + 7 - (date.tm_wday + 6) % 7) / 7);
      if ((date.tm_wday + 371 - date.tm_yday - 2) % 7 <= 2) {
        val++;
      }
      if (!val) {
        val = 52;
        var dec31 = (date.tm_wday + 7 - date.tm_yday - 1) % 7;
        if (dec31 == 4 || dec31 == 5 && isLeapYear(date.tm_year % 400 - 1)) {
          val++;
        }
      } else if (val == 53) {
        var jan1 = (date.tm_wday + 371 - date.tm_yday) % 7;
        if (jan1 != 4 && (jan1 != 3 || !isLeapYear(date.tm_year))) val = 1;
      }
      return leadingNulls(val, 2);
    },
    "%w": function w(date) {
      return date.tm_wday;
    },
    "%W": function W(date) {
      var days = date.tm_yday + 7 - (date.tm_wday + 6) % 7;
      return leadingNulls(Math.floor(days / 7), 2);
    },
    "%y": function y(date) {
      return (date.tm_year + 1900).toString().substring(2);
    },
    "%Y": function Y(date) {
      return date.tm_year + 1900;
    },
    "%z": function z(date) {
      var off = date.tm_gmtoff;
      var ahead = off >= 0;
      off = Math.abs(off) / 60;
      off = off / 60 * 100 + off % 60;
      return (ahead ? "+" : "-") + String("0000" + off).slice(-4);
    },
    "%Z": function Z(date) {
      return date.tm_zone;
    },
    "%%": function _() {
      return "%";
    }
  };
  pattern = pattern.replace(/%%/g, "\0\0");
  for (var rule in EXPANSION_RULES_2) {
    if (pattern.includes(rule)) {
      pattern = pattern.replace(new RegExp(rule, "g"), EXPANSION_RULES_2[rule](date));
    }
  }
  pattern = pattern.replace(/\0\0/g, "%");
  var bytes = intArrayFromString(pattern, false);
  if (bytes.length > maxsize) {
    return 0;
  }
  writeArrayToMemory(bytes, s);
  return bytes.length - 1;
};
var stringToUTF8OnStack = function stringToUTF8OnStack(str) {
  var size = lengthBytesUTF8(str) + 1;
  var ret = _stackAlloc(size);
  stringToUTF8(str, ret, size);
  return ret;
};
var getCFunc = function getCFunc(ident) {
  var func = Module["_" + ident];
  return func;
};
var ccall = function ccall(ident, returnType, argTypes, args, opts) {
  var toC = {
    "string": function string(str) {
      var ret = 0;
      if (str !== null && str !== undefined && str !== 0) {
        ret = stringToUTF8OnStack(str);
      }
      return ret;
    },
    "array": function array(arr) {
      var ret = _stackAlloc(arr.length);
      writeArrayToMemory(arr, ret);
      return ret;
    }
  };
  function convertReturnValue(ret) {
    if (returnType === "string") {
      return UTF8ToString(ret);
    }
    if (returnType === "boolean") return Boolean(ret);
    return ret;
  }
  var func = getCFunc(ident);
  var cArgs = [];
  var stack = 0;
  if (args) {
    for (var i = 0; i < args.length; i++) {
      var converter = toC[argTypes[i]];
      if (converter) {
        if (stack === 0) stack = _stackSave();
        cArgs[i] = converter(args[i]);
      } else {
        cArgs[i] = args[i];
      }
    }
  }
  var ret = func.apply(void 0, cArgs);
  function onDone(ret) {
    if (stack !== 0) _stackRestore(stack);
    return convertReturnValue(ret);
  }
  ret = onDone(ret);
  return ret;
};
function jsStackTrace() {
  return new Error().stack.toString();
}
function stackTrace() {
  var js = jsStackTrace();
  if (Module["extraStackTrace"]) js += "\n" + Module["extraStackTrace"]();
  return js;
}
FS.createPreloadedFile = FS_createPreloadedFile;
FS.staticInit();
Module["requestFullscreen"] = Browser.requestFullscreen;
Module["requestAnimationFrame"] = Browser.requestAnimationFrame;
Module["setCanvasSize"] = Browser.setCanvasSize;
Module["pauseMainLoop"] = Browser.mainLoop.pause;
Module["resumeMainLoop"] = Browser.mainLoop.resume;
Module["getUserMedia"] = Browser.getUserMedia;
Module["createContext"] = Browser.createContext;
var preloadedImages = {};
var preloadedAudios = {};
var GLctx;
for (var i = 0; i < 32; ++i) tempFixedLengthArray.push(new Array(i));
var miniTempWebGLFloatBuffersStorage = new Float32Array(288);
for (var i = 0; i < 288; ++i) {
  miniTempWebGLFloatBuffers[i] = miniTempWebGLFloatBuffersStorage.subarray(0, i + 1);
}
var miniTempWebGLIntBuffersStorage = new Int32Array(288);
for (var i = 0; i < 288; ++i) {
  miniTempWebGLIntBuffers[i] = miniTempWebGLIntBuffersStorage.subarray(0, i + 1);
}
var wasmImports = {
  b: ___assert_fail,
  Ph: ___syscall__newselect,
  Oh: ___syscall_accept4,
  Nh: ___syscall_bind,
  Mh: ___syscall_connect,
  Lh: ___syscall_dup3,
  g: ___syscall_fcntl64,
  Kh: ___syscall_getpeername,
  Jh: ___syscall_getsockname,
  aa: ___syscall_getsockopt,
  Ih: ___syscall_ioctl,
  Hh: ___syscall_listen,
  Gh: ___syscall_mkdirat,
  $: ___syscall_openat,
  Fh: ___syscall_poll,
  Eh: ___syscall_readlinkat,
  Dh: ___syscall_recvfrom,
  Ch: ___syscall_renameat,
  Bh: ___syscall_rmdir,
  Ah: ___syscall_sendto,
  va: ___syscall_socket,
  zh: ___syscall_stat64,
  _: ___syscall_unlinkat,
  wh: __emscripten_get_now_is_monotonic,
  vh: __emscripten_lookup_name,
  uh: __emscripten_system,
  th: __emscripten_throw_longjmp,
  Ba: __gmtime_js,
  Aa: __localtime_js,
  za: __mktime_js,
  sh: __tzset_js,
  F: _abort,
  rh: _dmDeviceJSFreeBufferSlots,
  qh: _dmDeviceJSOpen,
  ph: _dmDeviceJSQueue,
  oh: _dmGetDeviceSampleRate,
  nh: _dmScriptHttpRequestAsync,
  mh: _dmSysGetApplicationPath,
  lh: _dmSysGetUserAgent,
  kh: _dmSysGetUserPersistentDataRoot,
  jh: _dmSysGetUserPreferredLanguage,
  ih: _dmSysOpenURL,
  E: _emscripten_asm_const_int,
  hh: _emscripten_cancel_main_loop,
  D: _emscripten_date_now,
  gh: _emscripten_get_heap_max,
  ta: _emscripten_get_now,
  fh: _emscripten_glActiveTexture,
  eh: _emscripten_glAttachShader,
  dh: _emscripten_glBeginQuery,
  ch: _emscripten_glBeginQueryEXT,
  bh: _emscripten_glBeginTransformFeedback,
  ah: _emscripten_glBindAttribLocation,
  $g: _emscripten_glBindBuffer,
  _g: _emscripten_glBindBufferBase,
  Zg: _emscripten_glBindBufferRange,
  Yg: _emscripten_glBindFramebuffer,
  Xg: _emscripten_glBindRenderbuffer,
  Wg: _emscripten_glBindSampler,
  Vg: _emscripten_glBindTexture,
  Ug: _emscripten_glBindTransformFeedback,
  Tg: _emscripten_glBindVertexArray,
  Sg: _emscripten_glBindVertexArrayOES,
  Rg: _emscripten_glBlendColor,
  Qg: _emscripten_glBlendEquation,
  Pg: _emscripten_glBlendEquationSeparate,
  Og: _emscripten_glBlendFunc,
  Ng: _emscripten_glBlendFuncSeparate,
  Mg: _emscripten_glBlitFramebuffer,
  Lg: _emscripten_glBufferData,
  Kg: _emscripten_glBufferSubData,
  Jg: _emscripten_glCheckFramebufferStatus,
  Ig: _emscripten_glClear,
  Hg: _emscripten_glClearBufferfi,
  Gg: _emscripten_glClearBufferfv,
  Fg: _emscripten_glClearBufferiv,
  Eg: _emscripten_glClearBufferuiv,
  Dg: _emscripten_glClearColor,
  Cg: _emscripten_glClearDepthf,
  Bg: _emscripten_glClearStencil,
  Ag: _emscripten_glClientWaitSync,
  zg: _emscripten_glColorMask,
  yg: _emscripten_glCompileShader,
  xg: _emscripten_glCompressedTexImage2D,
  wg: _emscripten_glCompressedTexImage3D,
  vg: _emscripten_glCompressedTexSubImage2D,
  ug: _emscripten_glCompressedTexSubImage3D,
  tg: _emscripten_glCopyBufferSubData,
  sg: _emscripten_glCopyTexImage2D,
  rg: _emscripten_glCopyTexSubImage2D,
  qg: _emscripten_glCopyTexSubImage3D,
  pg: _emscripten_glCreateProgram,
  og: _emscripten_glCreateShader,
  ng: _emscripten_glCullFace,
  mg: _emscripten_glDeleteBuffers,
  lg: _emscripten_glDeleteFramebuffers,
  kg: _emscripten_glDeleteProgram,
  jg: _emscripten_glDeleteQueries,
  ig: _emscripten_glDeleteQueriesEXT,
  hg: _emscripten_glDeleteRenderbuffers,
  gg: _emscripten_glDeleteSamplers,
  fg: _emscripten_glDeleteShader,
  eg: _emscripten_glDeleteSync,
  dg: _emscripten_glDeleteTextures,
  cg: _emscripten_glDeleteTransformFeedbacks,
  bg: _emscripten_glDeleteVertexArrays,
  ag: _emscripten_glDeleteVertexArraysOES,
  $f: _emscripten_glDepthFunc,
  _f: _emscripten_glDepthMask,
  Zf: _emscripten_glDepthRangef,
  Yf: _emscripten_glDetachShader,
  Xf: _emscripten_glDisable,
  Wf: _emscripten_glDisableVertexAttribArray,
  Vf: _emscripten_glDrawArrays,
  Uf: _emscripten_glDrawArraysInstanced,
  Tf: _emscripten_glDrawArraysInstancedANGLE,
  Sf: _emscripten_glDrawArraysInstancedARB,
  Rf: _emscripten_glDrawArraysInstancedEXT,
  Qf: _emscripten_glDrawArraysInstancedNV,
  Pf: _emscripten_glDrawBuffers,
  Of: _emscripten_glDrawBuffersEXT,
  Nf: _emscripten_glDrawBuffersWEBGL,
  Mf: _emscripten_glDrawElements,
  Lf: _emscripten_glDrawElementsInstanced,
  Kf: _emscripten_glDrawElementsInstancedANGLE,
  Jf: _emscripten_glDrawElementsInstancedARB,
  If: _emscripten_glDrawElementsInstancedEXT,
  Hf: _emscripten_glDrawElementsInstancedNV,
  Gf: _emscripten_glDrawRangeElements,
  Ff: _emscripten_glEnable,
  Ef: _emscripten_glEnableVertexAttribArray,
  Df: _emscripten_glEndQuery,
  Cf: _emscripten_glEndQueryEXT,
  Bf: _emscripten_glEndTransformFeedback,
  Af: _emscripten_glFenceSync,
  zf: _emscripten_glFinish,
  yf: _emscripten_glFlush,
  xf: _emscripten_glFramebufferRenderbuffer,
  wf: _emscripten_glFramebufferTexture2D,
  vf: _emscripten_glFramebufferTextureLayer,
  uf: _emscripten_glFrontFace,
  tf: _emscripten_glGenBuffers,
  sf: _emscripten_glGenFramebuffers,
  rf: _emscripten_glGenQueries,
  qf: _emscripten_glGenQueriesEXT,
  pf: _emscripten_glGenRenderbuffers,
  of: _emscripten_glGenSamplers,
  nf: _emscripten_glGenTextures,
  mf: _emscripten_glGenTransformFeedbacks,
  lf: _emscripten_glGenVertexArrays,
  kf: _emscripten_glGenVertexArraysOES,
  jf: _emscripten_glGenerateMipmap,
  hf: _emscripten_glGetActiveAttrib,
  gf: _emscripten_glGetActiveUniform,
  ff: _emscripten_glGetActiveUniformBlockName,
  ef: _emscripten_glGetActiveUniformBlockiv,
  df: _emscripten_glGetActiveUniformsiv,
  cf: _emscripten_glGetAttachedShaders,
  bf: _emscripten_glGetAttribLocation,
  af: _emscripten_glGetBooleanv,
  $e: _emscripten_glGetBufferParameteri64v,
  _e: _emscripten_glGetBufferParameteriv,
  Ze: _emscripten_glGetError,
  Ye: _emscripten_glGetFloatv,
  Xe: _emscripten_glGetFragDataLocation,
  We: _emscripten_glGetFramebufferAttachmentParameteriv,
  Ve: _emscripten_glGetInteger64i_v,
  Ue: _emscripten_glGetInteger64v,
  Te: _emscripten_glGetIntegeri_v,
  Se: _emscripten_glGetIntegerv,
  Re: _emscripten_glGetInternalformativ,
  Qe: _emscripten_glGetProgramBinary,
  Pe: _emscripten_glGetProgramInfoLog,
  Oe: _emscripten_glGetProgramiv,
  Ne: _emscripten_glGetQueryObjecti64vEXT,
  Me: _emscripten_glGetQueryObjectivEXT,
  Le: _emscripten_glGetQueryObjectui64vEXT,
  Ke: _emscripten_glGetQueryObjectuiv,
  Je: _emscripten_glGetQueryObjectuivEXT,
  Ie: _emscripten_glGetQueryiv,
  He: _emscripten_glGetQueryivEXT,
  Ge: _emscripten_glGetRenderbufferParameteriv,
  Fe: _emscripten_glGetSamplerParameterfv,
  Ee: _emscripten_glGetSamplerParameteriv,
  De: _emscripten_glGetShaderInfoLog,
  Ce: _emscripten_glGetShaderPrecisionFormat,
  Be: _emscripten_glGetShaderSource,
  Ae: _emscripten_glGetShaderiv,
  ze: _emscripten_glGetString,
  ye: _emscripten_glGetStringi,
  xe: _emscripten_glGetSynciv,
  we: _emscripten_glGetTexParameterfv,
  ve: _emscripten_glGetTexParameteriv,
  ue: _emscripten_glGetTransformFeedbackVarying,
  te: _emscripten_glGetUniformBlockIndex,
  se: _emscripten_glGetUniformIndices,
  re: _emscripten_glGetUniformLocation,
  qe: _emscripten_glGetUniformfv,
  pe: _emscripten_glGetUniformiv,
  oe: _emscripten_glGetUniformuiv,
  ne: _emscripten_glGetVertexAttribIiv,
  me: _emscripten_glGetVertexAttribIuiv,
  le: _emscripten_glGetVertexAttribPointerv,
  ke: _emscripten_glGetVertexAttribfv,
  je: _emscripten_glGetVertexAttribiv,
  ie: _emscripten_glHint,
  he: _emscripten_glInvalidateFramebuffer,
  ge: _emscripten_glInvalidateSubFramebuffer,
  fe: _emscripten_glIsBuffer,
  ee: _emscripten_glIsEnabled,
  de: _emscripten_glIsFramebuffer,
  ce: _emscripten_glIsProgram,
  be: _emscripten_glIsQuery,
  ae: _emscripten_glIsQueryEXT,
  $d: _emscripten_glIsRenderbuffer,
  _d: _emscripten_glIsSampler,
  Zd: _emscripten_glIsShader,
  Yd: _emscripten_glIsSync,
  Xd: _emscripten_glIsTexture,
  Wd: _emscripten_glIsTransformFeedback,
  Vd: _emscripten_glIsVertexArray,
  Ud: _emscripten_glIsVertexArrayOES,
  Td: _emscripten_glLineWidth,
  Sd: _emscripten_glLinkProgram,
  Rd: _emscripten_glPauseTransformFeedback,
  Qd: _emscripten_glPixelStorei,
  Pd: _emscripten_glPolygonOffset,
  Od: _emscripten_glProgramBinary,
  Nd: _emscripten_glProgramParameteri,
  Md: _emscripten_glQueryCounterEXT,
  Ld: _emscripten_glReadBuffer,
  Kd: _emscripten_glReadPixels,
  Jd: _emscripten_glReleaseShaderCompiler,
  Id: _emscripten_glRenderbufferStorage,
  Hd: _emscripten_glRenderbufferStorageMultisample,
  Gd: _emscripten_glResumeTransformFeedback,
  Fd: _emscripten_glSampleCoverage,
  Ed: _emscripten_glSamplerParameterf,
  Dd: _emscripten_glSamplerParameterfv,
  Cd: _emscripten_glSamplerParameteri,
  Bd: _emscripten_glSamplerParameteriv,
  Ad: _emscripten_glScissor,
  zd: _emscripten_glShaderBinary,
  yd: _emscripten_glShaderSource,
  xd: _emscripten_glStencilFunc,
  wd: _emscripten_glStencilFuncSeparate,
  vd: _emscripten_glStencilMask,
  ud: _emscripten_glStencilMaskSeparate,
  td: _emscripten_glStencilOp,
  sd: _emscripten_glStencilOpSeparate,
  rd: _emscripten_glTexImage2D,
  qd: _emscripten_glTexImage3D,
  pd: _emscripten_glTexParameterf,
  od: _emscripten_glTexParameterfv,
  nd: _emscripten_glTexParameteri,
  md: _emscripten_glTexParameteriv,
  ld: _emscripten_glTexStorage2D,
  kd: _emscripten_glTexStorage3D,
  jd: _emscripten_glTexSubImage2D,
  id: _emscripten_glTexSubImage3D,
  hd: _emscripten_glTransformFeedbackVaryings,
  gd: _emscripten_glUniform1f,
  fd: _emscripten_glUniform1fv,
  ed: _emscripten_glUniform1i,
  dd: _emscripten_glUniform1iv,
  cd: _emscripten_glUniform1ui,
  bd: _emscripten_glUniform1uiv,
  ad: _emscripten_glUniform2f,
  $c: _emscripten_glUniform2fv,
  _c: _emscripten_glUniform2i,
  Zc: _emscripten_glUniform2iv,
  Yc: _emscripten_glUniform2ui,
  Xc: _emscripten_glUniform2uiv,
  Wc: _emscripten_glUniform3f,
  Vc: _emscripten_glUniform3fv,
  Uc: _emscripten_glUniform3i,
  Tc: _emscripten_glUniform3iv,
  Sc: _emscripten_glUniform3ui,
  Rc: _emscripten_glUniform3uiv,
  Qc: _emscripten_glUniform4f,
  Pc: _emscripten_glUniform4fv,
  Oc: _emscripten_glUniform4i,
  Nc: _emscripten_glUniform4iv,
  Mc: _emscripten_glUniform4ui,
  Lc: _emscripten_glUniform4uiv,
  Kc: _emscripten_glUniformBlockBinding,
  Jc: _emscripten_glUniformMatrix2fv,
  Ic: _emscripten_glUniformMatrix2x3fv,
  Hc: _emscripten_glUniformMatrix2x4fv,
  Gc: _emscripten_glUniformMatrix3fv,
  Fc: _emscripten_glUniformMatrix3x2fv,
  Ec: _emscripten_glUniformMatrix3x4fv,
  Dc: _emscripten_glUniformMatrix4fv,
  Cc: _emscripten_glUniformMatrix4x2fv,
  Bc: _emscripten_glUniformMatrix4x3fv,
  Ac: _emscripten_glUseProgram,
  zc: _emscripten_glValidateProgram,
  yc: _emscripten_glVertexAttrib1f,
  xc: _emscripten_glVertexAttrib1fv,
  wc: _emscripten_glVertexAttrib2f,
  vc: _emscripten_glVertexAttrib2fv,
  uc: _emscripten_glVertexAttrib3f,
  tc: _emscripten_glVertexAttrib3fv,
  sc: _emscripten_glVertexAttrib4f,
  rc: _emscripten_glVertexAttrib4fv,
  qc: _emscripten_glVertexAttribDivisor,
  pc: _emscripten_glVertexAttribDivisorANGLE,
  oc: _emscripten_glVertexAttribDivisorARB,
  nc: _emscripten_glVertexAttribDivisorEXT,
  mc: _emscripten_glVertexAttribDivisorNV,
  lc: _emscripten_glVertexAttribI4i,
  kc: _emscripten_glVertexAttribI4iv,
  jc: _emscripten_glVertexAttribI4ui,
  ic: _emscripten_glVertexAttribI4uiv,
  hc: _emscripten_glVertexAttribIPointer,
  gc: _emscripten_glVertexAttribPointer,
  fc: _emscripten_glViewport,
  ec: _emscripten_glWaitSync,
  dc: _emscripten_memcpy_js,
  cc: _emscripten_pause_main_loop,
  bc: _emscripten_resize_heap,
  Y: _emscripten_set_main_loop_arg,
  d: _emscripten_webgl_enable_extension,
  ac: _emscripten_webgl_get_current_context,
  yh: _environ_get,
  xh: _environ_sizes_get,
  X: _exit,
  G: _fd_close,
  ua: _fd_read,
  Ca: _fd_seek,
  Z: _fd_write,
  t: _getaddrinfo,
  o: _getnameinfo,
  sa: _glActiveTexture,
  W: _glAttachShader,
  e: _glBindBuffer,
  ra: _glBindBufferBase,
  V: _glBindFramebuffer,
  s: _glBindRenderbuffer,
  n: _glBindTexture,
  $b: _glBlendFunc,
  Q: _glBufferData,
  qa: _glBufferSubData,
  P: _glCheckFramebufferStatus,
  _b: _glClear,
  Zb: _glClearColor,
  Yb: _glClearDepthf,
  Xb: _glClearStencil,
  Wb: _glColorMask,
  C: _glCompileShader,
  m: _glCompressedTexImage2D,
  pa: _glCompressedTexImage3D,
  l: _glCompressedTexSubImage2D,
  Vb: _glCompressedTexSubImage3D,
  oa: _glCreateProgram,
  O: _glCreateShader,
  Ub: _glCullFace,
  na: _glDeleteBuffers,
  Tb: _glDeleteFramebuffers,
  U: _glDeleteProgram,
  k: _glDeleteRenderbuffers,
  B: _glDeleteShader,
  ma: _glDeleteTextures,
  Sb: _glDepthFunc,
  Rb: _glDepthMask,
  Qb: _glDisable,
  Pb: _glDisableVertexAttribArray,
  Ob: _glDrawArrays,
  Nb: _glDrawBuffers,
  Mb: _glDrawElements,
  Lb: _glEnable,
  Kb: _glEnableVertexAttribArray,
  Jb: _glFlush,
  Ib: _glFramebufferRenderbuffer,
  Hb: _glFramebufferTexture2D,
  Gb: _glFrontFace,
  T: _glGenBuffers,
  Fb: _glGenFramebuffers,
  A: _glGenRenderbuffers,
  la: _glGenTextures,
  Eb: _glGetActiveAttrib,
  Db: _glGetActiveUniform,
  N: _glGetActiveUniformBlockiv,
  ka: _glGetActiveUniformsiv,
  Cb: _glGetAttribLocation,
  c: _glGetError,
  Bb: _glGetFloatv,
  z: _glGetIntegerv,
  ja: _glGetProgramInfoLog,
  r: _glGetProgramiv,
  ia: _glGetShaderInfoLog,
  M: _glGetShaderiv,
  y: _glGetString,
  Ab: _glGetUniformBlockIndex,
  zb: _glGetUniformLocation,
  L: _glLinkProgram,
  ha: _glPixelStorei,
  yb: _glPolygonOffset,
  xb: _glReadPixels,
  S: _glRenderbufferStorage,
  wb: _glScissor,
  x: _glShaderSource,
  vb: _glStencilFunc,
  ub: _glStencilFuncSeparate,
  tb: _glStencilMask,
  sb: _glStencilOp,
  rb: _glStencilOpSeparate,
  i: _glTexImage2D,
  qb: _glTexImage3D,
  pb: _glTexParameterf,
  K: _glTexParameteri,
  j: _glTexSubImage2D,
  ob: _glTexSubImage3D,
  nb: _glUniform1i,
  mb: _glUniform4fv,
  lb: _glUniformBlockBinding,
  kb: _glUniformMatrix4fv,
  ga: _glUseProgram,
  jb: _glVertexAttribPointer,
  ib: _glViewport,
  hb: _glfwAccelerometerEnable,
  gb: _glfwCloseWindow,
  fb: _glfwDisable,
  eb: _glfwEnable,
  db: _glfwGetAcceleration,
  fa: _glfwGetDefaultFramebuffer,
  cb: _glfwGetDisplayScaleFactor,
  bb: _glfwGetJoystickButtons,
  ab: _glfwGetJoystickDeviceId,
  $a: _glfwGetJoystickHats,
  J: _glfwGetJoystickParam,
  _a: _glfwGetJoystickPos,
  Za: _glfwGetKey,
  h: _glfwGetMouseButton,
  Ya: _glfwGetMouseLocked,
  Xa: _glfwGetMousePos,
  Wa: _glfwGetMouseWheel,
  Va: _glfwGetWindowParam,
  Ua: _glfwGetWindowRefreshRate,
  ea: _glfwGetWindowSize,
  Ta: _glfwIconifyWindow,
  Sa: _glfwInitJS,
  da: _glfwOpenWindow,
  w: _glfwOpenWindowHint,
  Ra: _glfwPollEvents,
  Qa: _glfwResetKeyboard,
  Pa: _glfwSetCharCallback,
  Oa: _glfwSetDeviceChangedCallback,
  Na: _glfwSetGamepadCallback,
  Ma: _glfwSetMarkedTextCallback,
  La: _glfwSetTouchCallback,
  Ka: _glfwSetWindowBackgroundColor,
  Ja: _glfwSetWindowCloseCallback,
  Ia: _glfwSetWindowFocusCallback,
  Ha: _glfwSetWindowIconifyCallback,
  Ga: _glfwSetWindowSize,
  Fa: _glfwSetWindowSizeCallback,
  I: _glfwShowKeyboard,
  Ea: _glfwSwapBuffers,
  ca: _glfwSwapInterval,
  Da: _glfwTerminate,
  v: invoke_ii,
  q: invoke_iii,
  R: invoke_iiii,
  ya: invoke_ji,
  xa: invoke_jii,
  H: invoke_vi,
  u: invoke_vii,
  ba: invoke_viii,
  f: invoke_viiii,
  p: invoke_viiiii,
  a: wasmMemory,
  wa: _strftime
};
var wasmExports = createWasm();
var _wasm_call_ctors = function ___wasm_call_ctors() {
  return (_wasm_call_ctors = wasmExports["Qh"])();
};
var _main = Module["_main"] = function (a0, a1) {
  return (_main = Module["_main"] = wasmExports["Rh"])(a0, a1);
};
var _dmExportedSymbols = Module["_dmExportedSymbols"] = function () {
  return (_dmExportedSymbols = Module["_dmExportedSymbols"] = wasmExports["Sh"])();
};
var _malloc = Module["_malloc"] = function (a0) {
  return (_malloc = Module["_malloc"] = wasmExports["Th"])(a0);
};
var _free = Module["_free"] = function (a0) {
  return (_free = Module["_free"] = wasmExports["Uh"])(a0);
};
var _htonl2 = function _htonl(a0) {
  return (_htonl2 = wasmExports["Wh"])(a0);
};
var _dmScript_Html5ReportOperationSuccess = Module["_dmScript_Html5ReportOperationSuccess"] = function (a0) {
  return (_dmScript_Html5ReportOperationSuccess = Module["_dmScript_Html5ReportOperationSuccess"] = wasmExports["Xh"])(a0);
};
var _dmScript_RunInteractionCallback = Module["_dmScript_RunInteractionCallback"] = function () {
  return (_dmScript_RunInteractionCallback = Module["_dmScript_RunInteractionCallback"] = wasmExports["Yh"])();
};
var _setTempRet = function setTempRet0(a0) {
  return (_setTempRet = wasmExports["Zh"])(a0);
};
var _htons2 = function _htons(a0) {
  return (_htons2 = wasmExports["_h"])(a0);
};
var _ntohs2 = function _ntohs(a0) {
  return (_ntohs2 = wasmExports["$h"])(a0);
};
var _JSWriteDump = Module["_JSWriteDump"] = function (a0) {
  return (_JSWriteDump = Module["_JSWriteDump"] = wasmExports["ai"])(a0);
};
var _setThrew2 = function _setThrew(a0, a1) {
  return (_setThrew2 = wasmExports["bi"])(a0, a1);
};
var _stackSave = function stackSave() {
  return (_stackSave = wasmExports["ci"])();
};
var _stackRestore = function stackRestore(a0) {
  return (_stackRestore = wasmExports["di"])(a0);
};
var _stackAlloc = function stackAlloc(a0) {
  return (_stackAlloc = wasmExports["ei"])(a0);
};
var dynCall_ji = Module["dynCall_ji"] = function (a0, a1) {
  return (dynCall_ji = Module["dynCall_ji"] = wasmExports["fi"])(a0, a1);
};
var dynCall_jii = Module["dynCall_jii"] = function (a0, a1, a2) {
  return (dynCall_jii = Module["dynCall_jii"] = wasmExports["gi"])(a0, a1, a2);
};
function invoke_vii(index, a1, a2) {
  var sp = _stackSave();
  try {
    getWasmTableEntry(index)(a1, a2);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_ii(index, a1) {
  var sp = _stackSave();
  try {
    return getWasmTableEntry(index)(a1);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_viiiii(index, a1, a2, a3, a4, a5) {
  var sp = _stackSave();
  try {
    getWasmTableEntry(index)(a1, a2, a3, a4, a5);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_viiii(index, a1, a2, a3, a4) {
  var sp = _stackSave();
  try {
    getWasmTableEntry(index)(a1, a2, a3, a4);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_viii(index, a1, a2, a3) {
  var sp = _stackSave();
  try {
    getWasmTableEntry(index)(a1, a2, a3);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_iiii(index, a1, a2, a3) {
  var sp = _stackSave();
  try {
    return getWasmTableEntry(index)(a1, a2, a3);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_iii(index, a1, a2) {
  var sp = _stackSave();
  try {
    return getWasmTableEntry(index)(a1, a2);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_vi(index, a1) {
  var sp = _stackSave();
  try {
    getWasmTableEntry(index)(a1);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_ji(index, a1) {
  var sp = _stackSave();
  try {
    return dynCall_ji(index, a1);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
function invoke_jii(index, a1, a2) {
  var sp = _stackSave();
  try {
    return dynCall_jii(index, a1, a2);
  } catch (e) {
    _stackRestore(sp);
    if (e !== e + 0) throw e;
    _setThrew2(1, 0);
  }
}
Module["callMain"] = callMain;
Module["ccall"] = ccall;
Module["UTF8ToString"] = UTF8ToString;
Module["stringToNewUTF8"] = stringToNewUTF8;
Module["stackTrace"] = stackTrace;
var calledRun;
dependenciesFulfilled = function runCaller() {
  if (!calledRun) run();
  if (!calledRun) dependenciesFulfilled = runCaller;
};
function callMain() {
  var args = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : [];
  var entryFunction = _main;
  args.unshift(thisProgram);
  var argc = args.length;
  var argv = _stackAlloc((argc + 1) * 4);
  var argv_ptr = argv;
  args.forEach(function (arg) {
    HEAPU32[argv_ptr >> 2] = stringToUTF8OnStack(arg);
    argv_ptr += 4;
  });
  HEAPU32[argv_ptr >> 2] = 0;
  try {
    var ret = entryFunction(argc, argv);
    exitJS(ret, true);
    return ret;
  } catch (e) {
    return handleException(e);
  }
}
function run() {
  var args = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : arguments_;
  if (runDependencies > 0) {
    return;
  }
  preRun();
  if (runDependencies > 0) {
    return;
  }
  function doRun() {
    if (calledRun) return;
    calledRun = true;
    Module["calledRun"] = true;
    if (ABORT) return;
    initRuntime();
    preMain();
    if (Module["onRuntimeInitialized"]) Module["onRuntimeInitialized"]();
    if (shouldRunNow) callMain(args);
    postRun();
  }
  if (Module["setStatus"]) {
    Module["setStatus"]("Running...");
    setTimeout(function () {
      setTimeout(function () {
        Module["setStatus"]("");
      }, 1);
      doRun();
    }, 1);
  } else {
    doRun();
  }
}
if (Module["preInit"]) {
  if (typeof Module["preInit"] == "function") Module["preInit"] = [Module["preInit"]];
  while (Module["preInit"].length > 0) {
    Module["preInit"].pop()();
  }
}
var shouldRunNow = true;
if (Module["noInitialRun"]) shouldRunNow = false;
run();
