﻿
&НаКлиенте
Процедура УУ_ОформитьВместо(Команда)
	
	ОчиститьСообщения();
	
	МассивВСД = Новый Массив;
	
	Если ТТНПродукция = 0 Тогда //продукция
		
		Если НЕ ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокКОформлению, Ложь) Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого ИдентификаторСтроки Из Элементы.СписокКОформлению.ВыделенныеСтроки Цикл
			МассивВСД.Добавить(ИдентификаторСтроки);
		КонецЦикла;
		
		Если НЕ ВозможностьВводаВходящейТранспортнойОперации(МассивВСД) Тогда
			Возврат;
		КонецЕсли;
		
	Иначе 
		
		Если НЕ ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.СписокТТНКОформлению,Истина) Тогда
			Возврат;
		ИначеЕсли НЕ ПолучитьВСДПоОтбору(Элементы.СписокТТНКОформлению.ТекущиеДанные, МассивВСД) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр( "ru = 'Нет данных для заполнения'"),,"СписокТТНКОформлению");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	СоздатьВхТТН_Ветис(МассивВСД);
	
	//ОткрытьФорму("Документ.ВходящаяТранспортнаяОперацияВЕТИС.ФормаОбъекта",
	//	Новый Структура("Основание",МассивВСД), ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СоздатьВхТТН_Ветис(МассивВСД)
	
	НоваяВхТТН_ВЕТИС = Документы.ВходящаяТранспортнаяОперацияВЕТИС.СоздатьДокумент(); 
	НоваяВхТТН_ВЕТИС.Дата = ТекущаяДата();
	НоваяВхТТН_ВЕТИС.Заполнить(МассивВСД);
	ЗаполнитьДанныеАдресовМаршрутаПоОснованиям(НоваяВхТТН_ВЕТИС, МассивВСД);
	
	Попытка 
		НоваяВхТТН_ВЕТИС.Записать(РежимЗаписиДокумента.Запись);
		Сообщить("Создан документ " + НоваяВхТТН_ВЕТИС.Ссылка);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

// Заполняет адреса маршрута
// 
// Параметры:
// 	Основания - Массив, СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС - ВСД(1 или массив)-источник заполнения
&НаСервереБезКонтекста
Процедура ЗаполнитьДанныеАдресовМаршрутаПоОснованиям(ОбъектЗаполнения, Основания)
	
	ВСДДляЗаполнения = Неопределено;
	
	Если ТипЗнч(Основания) = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС") Тогда
		ВСДДляЗаполнения = Основания;
	ИначеЕсли ТипЗнч(Основания) = Тип("Массив")
		И Основания.Количество() > 0
		И ТипЗнч(Основания[0]) = Тип("СправочникСсылка.ВетеринарноСопроводительныйДокументВЕТИС") Тогда
		ВСДДляЗаполнения = Основания[0];
	КонецЕсли;  
	
	Если НЕ ВСДДляЗаполнения = Неопределено Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ВСДДляЗаполнения", ВСДДляЗаполнения);
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Маршрут.Предприятие КАК Предприятие,
		|	Маршрут.НомерСтроки КАК НомерСтроки,
		|	Маршрут.Адрес КАК Адрес,
		|	Маршрут.АдресПредставление КАК АдресПредставление,
		|	Маршрут.ДанныеАдреса КАК ДанныеАдреса
		|ИЗ
		|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Маршрут КАК Маршрут
		|ГДЕ
		|	Маршрут.Ссылка = &ВСДДляЗаполнения
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		
		МаршрутыВСД = Запрос.Выполнить().Выбрать();
		
		Если МаршрутыВСД.Количество() = ОбъектЗаполнения.Маршрут.Количество() Тогда
			
			Пока МаршрутыВСД.Следующий() Цикл
				СтрокаТЧ = ОбъектЗаполнения.Маршрут[МаршрутыВСД.НомерСтроки - 1];
				
				Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Предприятие)
				   И СтрокаТЧ.Адрес = МаршрутыВСД.Адрес
				   И СтрокаТЧ.АдресПредставление = МаршрутыВСД.АдресПредставление Тогда
					СтрокаТЧ.ДанныеАдресаСтруктура = МаршрутыВСД.ДанныеАдреса.Получить();
				КонецЕсли; 
				
			КонецЦикла;  
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
