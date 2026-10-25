import 'package:drift/drift.dart';

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get why => text().withDefault(const Constant(''))();
  TextColumn get type => text().withDefault(const Constant('general'))(); // general | money
  IntColumn get targetPaise => integer().nullable()();
  IntColumn get startAt => integer()();
  IntColumn get deadlineAt => integer()();
  IntColumn get priority => integer().withDefault(const Constant(3))();
  IntColumn get color => integer()();
  TextColumn get status => text().withDefault(const Constant('active'))(); // active|paused|done|dropped
  TextColumn get digest => text().nullable()();
  BoolColumn get digestStale => boolean().withDefault(const Constant(true))();
  IntColumn get digestAt => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Stages extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text()();
  TextColumn get title => text()();
  TextColumn get doneWhen => text().withDefault(const Constant(''))();
  IntColumn get dueAt => integer()();
  IntColumn get weight => integer().withDefault(const Constant(20))();
  IntColumn get orderIndex => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('open'))(); // open|done|dropped
  TextColumn get source => text().withDefault(const Constant('user'))(); // ai|user
  IntColumn get alignScore => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get doneAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'idx_todos_status_score', columns: {#status, #score})
class Todos extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text().nullable()();
  TextColumn get stageId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get normHash => text()();
  IntColumn get estimateMin => integer().withDefault(const Constant(30))();
  IntColumn get dueAt => integer().nullable()();
  IntColumn get remindAt => integer().nullable()();
  TextColumn get recurrence => text().withDefault(const Constant('none'))();
  IntColumn get score => integer().nullable()();
  TextColumn get scoreSource => text().withDefault(const Constant('rule'))(); // cache|rule|ai
  TextColumn get reason => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('open'))(); // open|done|dropped
  IntColumn get createdAt => integer()();
  IntColumn get doneAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class FocusSessions extends Table {
  TextColumn get id => text()();
  TextColumn get todoId => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('work'))();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  @override
  Set<Column> get primaryKey => {id};
}

class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()(); // wake|workout|sleep|deep_work
  TextColumn get title => text()();
  TextColumn get timeHhmm => text().withDefault(const Constant('06:30'))();
  IntColumn get daysMask => integer().withDefault(const Constant(127))(); // bit0 = Mon
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  TextColumn get configJson => text().withDefault(const Constant('{}'))();
  @override
  Set<Column> get primaryKey => {id};
}

class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phoneE164 => text()();
  TextColumn get channel => text().withDefault(const Constant('both'))(); // whatsapp|sms|both
  @override
  Set<Column> get primaryKey => {id};
}

class AppCategories extends Table {
  TextColumn get package => text()();
  TextColumn get label => text()();
  TextColumn get category => text()();
  BoolColumn get userSet => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {package};
}

@TableIndex(name: 'idx_usage_started', columns: {#startedAt})
class UsageSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get package => text()();
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer()();
  TextColumn get category => text()();
}

@TableIndex(name: 'idx_content_started', columns: {#startedAt})
class ContentItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get package => text()();
  TextColumn get title => text()();
  TextColumn get channelOrDomain => text().nullable()();
  TextColumn get kind => text().withDefault(const Constant('page'))(); // video|page|reels|feed|dm
  IntColumn get startedAt => integer()();
  IntColumn get endedAt => integer().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get classifiedBy => text().withDefault(const Constant('pending'))(); // rule|ai|user|pending
  TextColumn get titleHash => text()();
}

class ContentRules extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get matchType => text()(); // keyword|channel|domain
  TextColumn get value => text()();
  TextColumn get category => text()();
}

class ActivityDaily extends Table {
  TextColumn get date => text()();
  IntColumn get steps => integer().withDefault(const Constant(0))();
  IntColumn get distanceM => integer().withDefault(const Constant(0))();
  IntColumn get activeMin => integer().withDefault(const Constant(0))();
  IntColumn get exerciseMin => integer().withDefault(const Constant(0))();
  @override
  Set<Column> get primaryKey => {date};
}

@TableIndex(name: 'idx_money_date', columns: {#date})
class MoneyEntries extends Table {
  TextColumn get id => text()();
  TextColumn get goalId => text().nullable()();
  IntColumn get date => integer()();
  IntColumn get amountPaise => integer()();
  TextColumn get kind => text()(); // income|expense|saving
  TextColumn get category => text().withDefault(const Constant('general'))();
  TextColumn get note => text().nullable()();
  TextColumn get recurringId => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class MoneyRecurring extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get amountPaise => integer()();
  TextColumn get kind => text()();
  TextColumn get category => text().withDefault(const Constant('general'))();
  IntColumn get dayOfMonth => integer()();
  TextColumn get goalId => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  @override
  Set<Column> get primaryKey => {id};
}

@TableIndex(name: 'idx_nudge_at', columns: {#at})
class NudgeLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get at => integer()();
  TextColumn get type => text()();
  TextColumn get package => text().nullable()();
  TextColumn get todoId => text().nullable()();
  TextColumn get text_ => text().named('text')();
  TextColumn get action => text()(); // opened|snoozed|dismissed|ignored|blocked
}

class EventLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get at => integer()();
  TextColumn get source => text()(); // wake|escalation|alert|guard|ai|sync
  TextColumn get level => text().withDefault(const Constant('info'))();
  TextColumn get message => text()();
  TextColumn get dataJson => text().nullable()();
}

class AiCache extends Table {
  TextColumn get key => text()();
  TextColumn get kind => text()();
  TextColumn get responseJson => text()();
  IntColumn get createdAt => integer()();
  IntColumn get expiresAt => integer().nullable()();
  @override
  Set<Column> get primaryKey => {key};
}

class AiUsage extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get at => integer()();
  TextColumn get feature => text()();
  TextColumn get model => text()();
  IntColumn get inputTokens => integer().withDefault(const Constant(0))();
  IntColumn get outputTokens => integer().withDefault(const Constant(0))();
  IntColumn get cacheReadTokens => integer().withDefault(const Constant(0))();
  IntColumn get cacheWriteTokens => integer().withDefault(const Constant(0))();
}

class DailyRollup extends Table {
  TextColumn get date => text()();
  TextColumn get minutesByCategoryJson => text().withDefault(const Constant('{}'))();
  IntColumn get wastedMin => integer().withDefault(const Constant(0))();
  IntColumn get workMin => integer().withDefault(const Constant(0))();
  IntColumn get learningMin => integer().withDefault(const Constant(0))();
  TextColumn get topAppsJson => text().withDefault(const Constant('[]'))();
  @override
  Set<Column> get primaryKey => {date};
}

class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get valueJson => text()();
  @override
  Set<Column> get primaryKey => {key};
}
