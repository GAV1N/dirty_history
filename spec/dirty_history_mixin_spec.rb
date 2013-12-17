require 'bundler/setup'
Bundler.require(:development)
require 'active_support/all'
require './lib/dirty_history/dirty_history_mixin'

class Subject
  def self.has_many(*args); end
  def self.before_save(*args); end
  def self.after_save(*args); end

  def new_record?; true; end

  attr_accessor :changes

  include DirtyHistory::Mixin
  has_dirty_history :name
end

describe "#set_dirty_history_changes" do
  subject { Subject.new }

  context "when a tracked field changes" do
    it "captures the change" do
      subject.changes = {'name' => ['Adam', 'Bob']}
      subject.set_dirty_history_changes
      expect(subject.dirty_history_changes).to eql(name: ['Adam', 'Bob'])
    end

    it "captures changes to and from nil" do
      subject.changes = {'name' => [nil, 'Adam']}
      subject.set_dirty_history_changes
      expect(subject.dirty_history_changes).to eql(name: [nil, 'Adam'])

      subject.changes = {'name' => ['Adam', nil]}
      subject.set_dirty_history_changes
      expect(subject.dirty_history_changes).to eql(name: ['Adam', nil])
    end

    it "ignores changes from nil to empty string" do
      subject.changes = {'name' => [nil, '']}
      subject.set_dirty_history_changes
      expect(subject.dirty_history_changes).to eql({})
    end
  end

  context "when an untracked field changes" do
    it "ignores the change" do
      subject.changes = {'email' => ['adam@foo.com', 'bob@foo.com']}
      subject.set_dirty_history_changes
      expect(subject.dirty_history_changes).to eql({})
    end
  end
end
