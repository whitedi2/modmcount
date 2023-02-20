﻿
&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	ЗаписатьИЗакрытьНаСервере();
	ОбновитьИнтерфейсПриИзмененииФункциональныхОпций();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("СпособДоставкиПоУмолчанию", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "СпособДоставкиПоУмолчанию";
	ТекЭлОб.Значение = СпособДоставкиПоУмолчанию;
	ТекЭлОб.Записать();
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ОграничениеПравРедактированияКлючевыхСправочников", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ОграничениеПравРедактированияКлючевыхСправочников";
	ТекЭлОб.Значение = ОграничениеПравРедактированияКлючевыхСправочников;
	ТекЭлОб.Записать();
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ПроверятьЗаполнениеГоденДо", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ПроверятьЗаполнениеГоденДо";
	ТекЭлОб.Значение = ПроверятьЗаполнениеГоденДо;
	ТекЭлОб.Записать();
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ФормироватьНачисленияПоЗОтчетам", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ФормироватьНачисленияПоЗОтчетам";
	ТекЭлОб.Значение = ФормироватьНачисленияПоЗОтчетам;
	ТекЭлОб.Записать();
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("КонтрольМинимальнойЦеныПоТипуЦен", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "КонтрольМинимальнойЦеныПоТипуЦен";
	ТекЭлОб.Значение = КонтрольМинимальнойЦеныПоТипуЦен;
	ТекЭлОб.Записать();

   	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ФоноваяОбработкаБУДокументов", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ФоноваяОбработкаБУДокументов";
	ТекЭлОб.Значение = ФоноваяОбработкаБУДокументов;
	ТекЭлОб.Записать();
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ОбрабатыватьНепроведенныеБУДокументы", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ОбрабатыватьНепроведенныеБУДокументы";
	ТекЭлОб.Значение = ОбрабатыватьНепроведенныеБУДокументы;
	ТекЭлОб.Записать();
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ФоноваяПроверкаБУДокументов", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ФоноваяПроверкаБУДокументов";
	ТекЭлОб.Значение = ФоноваяПроверкаБУДокументов;
	ТекЭлОб.Записать();

	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ИспользоватьБизнесПроцессы", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ИспользоватьБизнесПроцессы";
	ТекЭлОб.Значение = ИспользоватьБизнесПроцессы;
	ТекЭлОб.Записать();
	Константы.ИспользоватьБизнесПроцессыИЗадачи.Установить(ИспользоватьБизнесПроцессы);
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ПроверятьЗаполнениеДоговоровВДокументах", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ПроверятьЗаполнениеДоговоровВДокументах";
	ТекЭлОб.Значение = ПроверятьЗаполнениеДоговоровВДокументах;
	ТекЭлОб.Записать();
	
	ТекЭл = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ИспользоватьФО", Истина);
	
	Если ЗначениеЗаполнено(ТекЭл) Тогда
		ТекЭлОб = ТекЭл.ПолучитьОбъект();
	Иначе
		ТекЭлОб = Справочники.сабМониторВнедрения.СоздатьЭлемент();
	КонецЕсли;
	
	ТекЭлОб.Наименование = "ИспользоватьФО";
	ТекЭлОб.Значение = Истина;
	ТекЭлОб.Записать();
	
	Константы.сабПодсистемаКазначейство.Установить(сабПодсистемаКазначейство);
	Константы.сабПодсистемаБюджетирование.Установить(сабПодсистемаБюджетирование);
	Константы.сабПодсистемаДокументооборот.Установить(сабПодсистемаДокументооборот);
	Константы.сабПодсистемаОперативныйУчет.Установить(сабПодсистемаОперативныйУчет);
	
	Константы.ИспользоватьБизнесПроцессыЗаявокСотрудников.Установить(ВключитьСправочникПодразделения);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СпособДоставкиПоУмолчанию = Справочники.сабМониторВнедрения.НайтиПоНаименованию("СпособДоставкиПоУмолчанию", Истина).Значение; 
	ОграничениеПравРедактированияКлючевыхСправочников = справочники.сабМониторВнедрения.НайтиПоНаименованию("ОграничениеПравРедактированияКлючевыхСправочников", Истина).Значение;
	ПроверятьЗаполнениеГоденДо = справочники.сабМониторВнедрения.НайтиПоНаименованию("ПроверятьЗаполнениеГоденДо", Истина).Значение;
	ФормироватьНачисленияПоЗОтчетам = справочники.сабМониторВнедрения.НайтиПоНаименованию("ФормироватьНачисленияПоЗОтчетам", Истина).Значение;
	ФоноваяОбработкаБУДокументов = справочники.сабМониторВнедрения.НайтиПоНаименованию("ФоноваяОбработкаБУДокументов", Истина).Значение;
	ФоноваяПроверкаБУДокументов = справочники.сабМониторВнедрения.НайтиПоНаименованию("ФоноваяПроверкаБУДокументов", Истина).Значение;
	ОбрабатыватьНепроведенныеБУДокументы = справочники.сабМониторВнедрения.НайтиПоНаименованию("ОбрабатыватьНепроведенныеБУДокументы", Истина).Значение;
	ИспользоватьБизнесПроцессы = справочники.сабМониторВнедрения.НайтиПоНаименованию("ИспользоватьБизнесПроцессы", Истина).Значение;
	ПроверятьЗаполнениеДоговоровВДокументах = справочники.сабМониторВнедрения.НайтиПоНаименованию("ПроверятьЗаполнениеДоговоровВДокументах", Истина).Значение;
	КонтрольМинимальнойЦеныПоТипуЦен = справочники.сабМониторВнедрения.НайтиПоНаименованию("КонтрольМинимальнойЦеныПоТипуЦен", Истина).Значение;
	
	сабПодсистемаКазначейство = Константы.сабПодсистемаКазначейство.Получить();
	сабПодсистемаБюджетирование = Константы.сабПодсистемаБюджетирование.Получить();
	сабПодсистемаДокументооборот = Константы.сабПодсистемаДокументооборот.Получить();
	сабПодсистемаОперативныйУчет = Константы.сабПодсистемаОперативныйУчет.Получить();
	
	ВключитьСправочникПодразделения = Константы.ИспользоватьБизнесПроцессыЗаявокСотрудников.Получить();
	
	ФоноваяОбработкаБУДокументовПриИзмененииНаСервере();
	
	ТекСтрокаЛицензии = Справочники.сабМониторВнедрения.НайтиПоНаименованию("Ключ лицензии", Истина);
	СтруктураЛицензий = РегистрыСведений.сабСоответствияОрганизацийПредприятиям.ПроверитьЛицензиюМодуля();
	Если СтруктураЛицензий.ПолныеЛицензии.Найти(ТекСтрокаЛицензии.Значение) = Неопределено Тогда
		Элементы.ИспользоватьБизнесПроцессы.Доступность = Ложь;
		Элементы.ВключитьСправочникПодразделения.Доступность = Ложь;
		Элементы.сабПодсистемаДокументооборот.Доступность = Ложь;
	Иначе
		Элементы.Декорация1.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ФоноваяОбработкаБУДокументовПриИзмененииНаСервере()
	Элементы.ФоноваяПроверкаБУДокументов.Доступность = ФоноваяОбработкаБУДокументов;
	Если Не ФоноваяОбработкаБУДокументов Тогда
		ФоноваяПроверкаБУДокументов = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФоноваяОбработкаБУДокументовПриИзменении(Элемент)
	ФоноваяОбработкаБУДокументовПриИзмененииНаСервере();
КонецПроцедуры
