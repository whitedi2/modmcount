﻿
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ВидДокумента = "Реестр платежей" Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	МаршрутыДвиженияЗаявок.Ссылка
		|ИЗ
		|	Справочник.МаршрутыДвиженияЗаявок КАК МаршрутыДвиженияЗаявок
		|ГДЕ
		|	МаршрутыДвиженияЗаявок.Ссылка <> &Ссылка
		|	И МаршрутыДвиженияЗаявок.ВидДокумента = ""Реестр платежей""
		|	И МаршрутыДвиженияЗаявок.Наименование = &Наименование";
		Запрос.УстановитьПараметр("Наименование", Наименование);
		//Запрос.УстановитьПараметр("Предприятие", Предприятие);
		//Запрос.УстановитьПараметр("Подразделение", Подразделение);
		//Запрос.УстановитьПараметр("СтатьяДДС", СтатьяДДС);
		//Запрос.УстановитьПараметр("ТипПлатежа", ТипПлатежа);
		//Запрос.УстановитьПараметр("ВыдачаВПодОтчет", ВыдачаВПодОтчет);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Сообщить("Предприятие и статья уже заданы в маршруте " + Выборка.Ссылка);
			Отказ = Истина;
		КонецЦикла;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если НЕ ЗначениеЗаполнено(Автор) Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	//подписка на событие
	БюджетныйНаСервере.ПередЗаписиЭлементовСправочниковПриЗаписи(ЭтотОбъект, Отказ);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Автор = "";
КонецПроцедуры

#Область ОбновлениеИнформационнойБазы

Процедура УстановтьНастройкиПоУмолчанию() Экспорт
	
	СпрОсновной = Справочники.МаршрутыДвиженияЗаявок.НайтиПоНаименованию("Основной маршрут");
	
	Если ЗначениеЗаполнено(СпрОсновной) Тогда
		СпрОбъект = СпрОсновной.ПолучитьОбъект();
		Если Не ЗначениеЗаполнено(СпрОбъект.ВидДокумента) Тогда
			СпрОбъект.ВидДокумента = "Реестр платежей";
		КонецЕсли;
		Если СпрОбъект.ПредприятияПодразделения.Количество() = 0 Тогда
			СпрОбъект.ПредприятияПодразделения.Добавить();
		КонецЕсли;
		Если СпрОбъект.СтатьиДДС.Количество() = 0 Тогда
			СпрОбъект.СтатьиДДС.Добавить();
		КонецЕсли;
		СпрОбъект.Записать();
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти