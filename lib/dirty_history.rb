require "dirty_history/version"
require "active_record"

$LOAD_PATH.unshift(File.dirname(__FILE__))

autoload :DirtyHistoryRecord, "dirty_history/dirty_history_record"
require "dirty_history/dirty_history_mixin"  

ActiveRecord::Base.send :include, DirtyHistory::Mixin

$LOAD_PATH.shift

