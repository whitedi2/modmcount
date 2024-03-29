﻿
///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ТИПОВ

//Функция описание типа договора
//
Функция ПолучитьОписаниеТиповДоговора() Экспорт
	
	Возврат Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов");
	
КонецФункции

//Функция возвращает описание типа банковского счета организации
//
Функция ТипЗначенияБанковскогоСчетаОрганизации() Экспорт
	
	Возврат Тип("СправочникСсылка.БанковскиеСчета");

КонецФункции

// Функция ПолучитьОписаниеТиповБанковскогоСчетаОрганизации ОписаниеТипов
// для банковских счетов организаций.
//
Функция ПолучитьОписаниеТиповБанковскогоСчетаОрганизации() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета");	

КонецФункции // ПолучитьОписаниеТиповБанковскогоСчетаОрганизации()

// Функция ПолучитьОписаниеТиповНоменклатурнойГруппы возвращает 
// тип для номенклатурной группы.
//
Функция ПолучитьОписаниеТиповНоменклатурнойГруппы() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.НоменклатурныеГруппы");

КонецФункции

// Функция ОписаниеТиповПодразделения возвращает 
// описание типов для справочника подразделений.
//
Функция ОписаниеТиповПодразделения() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");

КонецФункции

//Функция возвращает тип для справочника подразделений.
//
Функция ТипПодразделения() Экспорт
	
	Возврат Тип("СправочникСсылка.ПодразделенияОрганизаций");

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ХАРАКТЕРА ОПЕРАЦИИ ПО ТИПУ РЕГИСТРАТОРОВ

// Функция проверяет, является ли переданный по ссылке документ документом возврата товаров.
//
Функция ДокументЯвляетсяВозвратом(СсылкаНаДокумент) Экспорт

	Возврат ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя");	
	
КонецФункции // ДокументЯвляетсяВозвратом()

// Функция проверяет, является ли переданный по ссылке документ документом реализации отгруженных товаров.
//
Функция ДокументЯвляетсяРеализациейОтгруженныхТоваров(СсылкаНаДокумент) Экспорт

	Возврат ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.РеализацияОтгруженныхТоваров");	
	
КонецФункции // ДокументЯвляетсяРеализациейОтгруженныхТоваров()

// Функция ДокументЯвляетсяРеализацией возвращает Истина, если переданный по ссылке документ
// является документом реализации (товаров, услуг, ОС, НМА)
//
Функция ДокументЯвляетсяРеализацией(СсылкаНаДокумент) Экспорт

	ТипДокумента = ТипЗнч(СсылкаНаДокумент);

	Возврат ТипДокумента = Тип("ДокументСсылка.АктОбОказанииПроизводственныхУслуг")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.КорректировкаРеализации")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.ОказаниеУслуг")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.ОтчетОРозничныхПродажах")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.ПередачаНМА")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.ПередачаОС")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.РеализацияТоваровУслуг")
			ИЛИ ТипДокумента = Тип("ДокументСсылка.РеализацияУслугПоПереработке");

КонецФункции // ДокументЯвляетсяРеализацией()

// Функция проверяет, является ли переданный по ссылке документ отчетом комитенту.
//
Функция ДокументЯвляетсяОтчетомКомитенту(СсылкаНаДокумент) Экспорт

	Возврат ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ОтчетКомитентуОПродажах");	
	
КонецФункции // ДокументЯвляетсяОтчетомКомитенту()

// Функция проверяет, является ли переданный по ссылке документ поступление доп.расходов.
//
Функция ДокументЯвляетсяПоступлениемДопРасходов(СсылкаНаДокумент) Экспорт

	Возврат ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.ПоступлениеДопРасходов");	
	
КонецФункции // ДокументЯвляетсяОтчетомКомитенту()

// Функция ЭтоРегламентнаяОперация возвращает Истина, если переданный по ссылке документ
// является документом регламентной операции.
//
Функция ЭтоРегламентнаяОперация(СсылкаНаДокумент) Экспорт

	Возврат ТипЗнч(СсылкаНаДокумент) = Тип("ДокументСсылка.РегламентнаяОперация");

КонецФункции // ЭтоРегламентнаяОперация()

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ИМЕН РЕКВИЗИТОВ

// Функция ПолучитьИмяРеквизитаКонтрагентДоговора имя реквизита в справочнике
// ДоговорыКонтрагентов, в котором храниться ссылка на контрагента-владельца.
//
Функция ПолучитьИмяРеквизитаКонтрагентДоговора() Экспорт

	Возврат "Владелец";

КонецФункции

// Функция ПолучитьИмяРеквизитаВидДоговора имя реквизита в справочнике
// ДоговорыКонтрагентов, по которому определяется вид договора.
//
Функция ПолучитьИмяРеквизитаВидДоговора() Экспорт

	Возврат "ВидДоговора";

КонецФункции

// Функция ПолучитьИмяРеквизитаНоменклатурнаяГруппаНоменклатуры возвращает 
// имя реквизита НоменклатурнаяГруппа в справочнике Номенклатура
//
Функция ПолучитьИмяРеквизитаНоменклатурнаяГруппаНоменклатуры() Экспорт

	Возврат "НоменклатурнаяГруппа";

КонецФункции

Функция ПолучитьИмяСправочникаНоменклатурныеГруппы() Экспорт

	Возврат "НоменклатурныеГруппы";

КонецФункции

// Функция возвращает строку с именем реквизита в справочнике подразделений,
// определяющего организацию подразделения, либо пустую строку, если справочник 
// подразделений не является подчиненным справочником.
//
Функция ИмяРеквизитаОрганизацияПодразделения() Экспорт
	
	Возврат "Владелец";

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ СООБЩЕНИЙ

// Функция возвращает строку с навигационной ссылкой на раздел ОС и НМА.
//
Функция ПолучитьНавигационнуюСсылкуНаРазделОСиНМА() Экспорт

	Возврат "e1cib/navigationpoint/ОсновныеСредстваИНМА";

КонецФункции // ПолучитьНавигационнуюСсылкуНаРазделОСиНМА()

// Функция возвращает строку с навигационной ссылкой для открытия учетной политики организации.
//
Функция ПолучитьНавигационнуюСсылкуНаУчетнуюПолитикуОрганизации() Экспорт

	Возврат "e1cib/navigationpoint/БухгалтерскийИНалоговыйУчет.УчетнаяПолитика/РегистрСведений.УчетнаяПолитикаОрганизаций.Команда.ОткрытьСписок";

КонецФункции // ПолучитьНавигационнуюСсылкуНаУчетнуюПолитикуОрганизации()
