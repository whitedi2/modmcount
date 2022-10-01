﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	//Если ТипЗнч(ДокОснование) = Тип("ДокументСсылка.УЧ_РеализацияНовый") И ФлагВозврат Тогда
	//	ОбработкаПроведенияРеализацииНовый();
	//Иначе
	//	ОбработкаПроведенияОбщая();
	//КонецЕсли;
	ОбработкаПроведенияОбщая();	
КонецПроцедуры

Процедура ОбработкаПроведенияОбщая()
	
	Если РучнаяКорректировка Тогда		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Движения документа %1 отредактированы вручную и не могут быть автоматически актуализированы'"), ЭтотОбъект);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.КлючДанных = Ссылка;
		Сообщение.Сообщить();		
		
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	*
		|ИЗ
		|	РегистрБухгалтерии.Учетный.ДвиженияССубконто(, , Регистратор = &ВыбРегистратр, , ) КАК УчетныйДвиженияССубконто";

	Запрос.УстановитьПараметр("ВыбРегистратр", ДокОснование);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Движения.Учетный.Записывать = Истина;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл 
		Движение = Движения.Учетный.Добавить();
		Движение.Период = Дата;
		Движение.СчетДт = ВыборкаДетальныеЗаписи.СчетДт;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ВыборкаДетальныеЗаписи.СчетДт,1,ВыборкаДетальныеЗаписи.СубконтоДт1);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ВыборкаДетальныеЗаписи.СчетДт,2,ВыборкаДетальныеЗаписи.СубконтоДт2);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,ВыборкаДетальныеЗаписи.СчетДт,3,ВыборкаДетальныеЗаписи.СубконтоДт3);
		Движение.СчетКт = ВыборкаДетальныеЗаписи.СчетКт;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,ВыборкаДетальныеЗаписи.СчетКт,1,ВыборкаДетальныеЗаписи.СубконтоКт1);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,ВыборкаДетальныеЗаписи.СчетКт,2,ВыборкаДетальныеЗаписи.СубконтоКт2);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,ВыборкаДетальныеЗаписи.СчетКт,3,ВыборкаДетальныеЗаписи.СубконтоКт3);
		Если ВыборкаДетальныеЗаписи.СчетДт.Количественный Тогда
			Движение.КоличествоДт = -ВыборкаДетальныеЗаписи.КоличествоДт;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.СчетКт.Количественный Тогда
			Движение.КоличествоКт = -ВыборкаДетальныеЗаписи.КоличествоКт;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.СчетДт.Крахмал Тогда
			Движение.КоличествоКРХДт = -ВыборкаДетальныеЗаписи.КоличествоКрхДт;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.СчетКт.Крахмал Тогда
			Движение.КоличествоКРХКт = -ВыборкаДетальныеЗаписи.КоличествоКРХКт;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.СчетДт.Валютный Тогда
			Движение.ВалютаДт = ВыборкаДетальныеЗаписи.ВалютаДт;
			Движение.ВалютнаяСуммаДт = -ВыборкаДетальныеЗаписи.ВалютнаяСуммаДт;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.СчетКт.Валютный Тогда
			Движение.ВалютаКт = ВыборкаДетальныеЗаписи.ВалютаКт;
			Движение.ВалютнаяСуммаКт = -ВыборкаДетальныеЗаписи.ВалютнаяСуммаКт;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.СчетДт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеДт = ВыборкаДетальныеЗаписи.ПодразделениеДт;
		КонецЕсли;
		Если ВыборкаДетальныеЗаписи.СчетКт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеКт = ВыборкаДетальныеЗаписи.ПодразделениеКт;
		КонецЕсли;
		Движение.Предприятия = ВыборкаДетальныеЗаписи.Предприятия;
		Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		Движение.Сумма = -ВыборкаДетальныеЗаписи.Сумма;
		Движение.НомерСтрокиДок = ВыборкаДетальныеЗаписи.НомерСтрокиДок;
		Движение.Содержание = "Сторно " + ВыборкаДетальныеЗаписи.Содержание  + "
		|" + Комментарий;
	КонецЦикла;
	
	//Движения по регистру Реализация
	//Движения.Реализация.Записывать = Истина;
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Реализация.Предприятие,
	//	|	Реализация.Контрагент,
	//	|	Реализация.Номенклатура,
	//	|	Реализация.Количество,
	//	|	Реализация.СуммаОтгрузки,
	//	|	Реализация.СуммаТранспорт,
	//	|	Реализация.СуммаВерх,
	//	|	Реализация.СуммаМенеджер,
	//	|	Реализация.Себестоимость,
	//	|	Реализация.КоличествоОбъем,
	//	|	Реализация.СуммаТранспортНачисленоАвто,
	//	|	Реализация.Менеджер,
	//	|	Реализация.Километраж,
	//	|	Реализация.НомерМашины,
	//	|	Реализация.НомерЦистерны,
	//	|	Реализация.КоммерческийДиректор,
	//	|	Реализация.СуммаТранспортНачисленоЖд,
	//	|	Реализация.СуммаТранспортНачисленоСопровождение
	//	|ИЗ
	//	|	РегистрНакопления.Реализация КАК Реализация
	//	|ГДЕ
	//	|	Реализация.Регистратор = &ВыбРегистратор";

	//Запрос.УстановитьПараметр("ВыбРегистратор", ДокОснование);

	//Результат = Запрос.Выполнить();

	//ВыборкаДетальныеЗаписиР = Результат.Выбрать();

	//Пока ВыборкаДетальныеЗаписиР.Следующий() Цикл
	//	Движение = Движения.Реализация.Добавить();
	//	Движение.Период = Дата;
	//	Движение.Предприятие = ВыборкаДетальныеЗаписиР.Предприятие;
	//	Движение.Контрагент = ВыборкаДетальныеЗаписиР.Контрагент;
	//	Движение.Номенклатура = ВыборкаДетальныеЗаписиР.Номенклатура;
	//	Движение.Количество = -ВыборкаДетальныеЗаписиР.Количество;
	//	Движение.КоличествоОбъем = -ВыборкаДетальныеЗаписиР.КоличествоОбъем;
	//	Движение.СуммаОтгрузки = -ВыборкаДетальныеЗаписиР.СуммаОтгрузки;
	//	Движение.СуммаТранспорт = -ВыборкаДетальныеЗаписиР.СуммаТранспорт;
	//	Движение.СуммаТранспортНачисленоАвто = -ВыборкаДетальныеЗаписиР.СуммаТранспортНачисленоАвто;
	//	Движение.СуммаТранспортНачисленоЖд = -ВыборкаДетальныеЗаписиР.СуммаТранспортНачисленоЖд;				
	//	Движение.СуммаТранспортНачисленоСопровождение = -ВыборкаДетальныеЗаписиР.СуммаТранспортНачисленоСопровождение;				
	//	Движение.СуммаМенеджер = -ВыборкаДетальныеЗаписиР.СуммаМенеджер;
	//	Движение.СуммаВерх = -ВыборкаДетальныеЗаписиР.СуммаВерх;
	//	Движение.Себестоимость = -ВыборкаДетальныеЗаписиР.Себестоимость;
	//	Движение.КоммерческийДиректор = ВыборкаДетальныеЗаписиР.КоммерческийДиректор;			
	//	Движение.Менеджер = ВыборкаДетальныеЗаписиР.Менеджер;			
	//	Движение.Километраж = -ВыборкаДетальныеЗаписиР.Километраж;			
	//	Движение.НомерМашины = ВыборкаДетальныеЗаписиР.НомерМашины;			
	//	Движение.НомерЦистерны = ВыборкаДетальныеЗаписиР.НомерЦистерны;			
	//КонецЦикла;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	РеквизитыСумм = Новый Массив;
	РеквизитыСумм.Добавить("СуммаДокумента");
	РеквизитыСумм.Добавить("СуммаИтог");
	
	Для каждого Реквизит Из ДокОснование.Метаданные().Реквизиты Цикл
		Если НЕ РеквизитыСумм.Найти(Реквизит.Имя) = Неопределено Тогда
			СуммаДокумента = - ДокОснование[Реквизит.Имя];
		КонецЕсли;
	КонецЦикла;
	
	Эл = Метаданные.ОбщиеРеквизиты.СуммаДокумента.Состав.Найти(ДокОснование.Метаданные());
	Если НЕ ДокОснование.Метаданные().Реквизиты.Найти("СуммаДокумента") = Неопределено ИЛИ Эл.Использование = Метаданные.СвойстваОбъектов.ИспользованиеОбщегоРеквизита.Использовать Тогда
		СуммаДокумента = - ДокОснование["СуммаДокумента"];
	КонецЕсли; 
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Константы.сабМодульОперативныйУчет.Получить() Тогда
		ПроверяемыеРеквизиты.Добавить("Подразделение");	
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	РучнаяКорректировка = Ложь;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

//Процедура ОбработкаПроведенияРеализацииНовый()
//	//запрос на среднюю себестоимость по товарам
//	Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	|	ЕСТЬNULL(УчетныйОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
//	|	ЕСТЬNULL(УчетныйОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
//	|	УчетныйОстатки.Субконто1,
//	|	УчетныйОстатки.Счет,
//	|	УчетныйОстатки.Субконто2
//	|ИЗ
//	|	РегистрБухгалтерии.Учетный.Остатки(
//	|			&Дата,
//	|			Счет В ИЕРАРХИИ (&Счет),
//	|			,
//	|			Предприятия В ИЕРАРХИИ (&Предприятия)
//	|				И ВЫБОР
//	|					КОГДА &Подразделение = ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка)
//	|						ТОГДА ИСТИНА
//	|					ИНАЧЕ Подразделение = &Подразделение
//	|				КОНЕЦ
//	|				И СценарийПлана = &СценарийПлана) КАК УчетныйОстатки";
//	
//	
//	МассивСчетов = Новый Массив;
//	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет41());//товары
//	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет10());//сырье
//	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет01());//ОС
//	
//	//если на корсчетах отсутствует подразделение
//	Если НЕ ДокОснование.СчетКт.УчетПоПодразделениям Тогда
//		ВидДеятельностиЗапрос = Справочники.СтруктураПредприятия.ПустаяСсылка();	
//	Иначе
//		ВидДеятельностиЗапрос = ДокОснование.ВидДеятельности;	
//	КонецЕсли;
//	
//	Запрос.УстановитьПараметр("Дата", Дата);
//	Запрос.УстановитьПараметр("Предприятия", Предприятие);
//	Запрос.УстановитьПараметр("Подразделение", ВидДеятельностиЗапрос);
//	Запрос.УстановитьПараметр("Счет", ДокОснование.СчетКт);
//	Запрос.УстановитьПараметр("СценарийПлана", Справочники.СценарииПланирования.Факт);
//	
//	РезультатСебест = Запрос.Выполнить();
//	
//	// регистр Учетный 
//	Движения.Учетный.Записывать = Истина;
//	Движения.Реализация.Записывать = Истина;
//	
//	Если ТипЗнч(ДокОснование.Субконто1) = Тип("СправочникСсылка.Номенклатура") Тогда
//		//выручка
//		Движение = Движения.Учетный.Добавить();
//		Если ДокОснование.Флаг60_79 = 0 Тогда
//			Движение.СчетДт = ДокОснование.Счет;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина)] = ДокОснование.Контрагент;
//		Иначе
//			Движение.СчетДт = ПланыСчетов.Учетный.Счет7902();
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Предприятия", Истина)] = ДокОснование.ПредприятиеПоставщик;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Внутренние договоры", Истина)] = ДокОснование.ДоговорВн;
//		КонецЕсли;
//		Движение.СчетКт = ПланыСчетов.Учетный.Счет9004();
//		Движение.Период = Дата;
//		Движение.Предприятия = Предприятие;
//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//		Движение.Сумма = -ДокОснование.СуммаОтгрузки;
//		Движение.НомерСтрокиДок = 1;
//		Движение.Содержание = "Сторно " + ДокОснование;
//		Если ДокОснование.Счет = ПланыСчетов.Учетный.Счет6201() Тогда
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина)] = ДокОснование.Договор;
//			Движение.ПодразделениеДт = ДокОснование.ВидДеятельности;		
//		КонецЕсли;
//		
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ДокОснование.Субконто1;
//		
//		//себестоимость
//		Выборка = РезультатСебест.Выбрать();
//		СтрукутраПоиска = Новый Структура("Субконто1, Счет, Субконто2", ДокОснование.Субконто1, ДокОснование.СчетКт, ДокОснование.Субконто2) ;
//		Если Выборка.НайтиСледующий(СтрукутраПоиска) Тогда
//			Себестоимость = ?(Выборка.КоличествоОстаток, Выборка.СуммаОстаток / Выборка.КоличествоОстаток, 0);
//		Иначе
//			Себестоимость = 0;
//		КонецЕсли;
//		
//		Движение = Движения.Учетный.Добавить();
//		Движение.СчетДт = ПланыСчетов.Учетный.Счет9004();
//		Движение.СчетКт = ДокОснование.СчетКт;
//		Если ДокОснование.СчетКт.УчетПоПодразделениям Тогда
//			Движение.ПодразделениеКт = ДокОснование.ВидДеятельности;
//		КонецЕсли;
//		Движение.Период = Дата;
//		Движение.Предприятия = Предприятие;
//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//		Движение.Сумма = -Себестоимость * ДокОснование.Количество;
//		Движение.КоличествоКт = -ДокОснование.Количество;
//		Если ДокОснование.СчетКт.Крахмал Тогда
//			Движение.КоличествоКРХКт = -ДокОснование.КоличествоКРХ;
//		КонецЕсли;
//		Движение.Содержание = "Сторно " + ДокОснование;
//		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ДокОснование.Субконто1;
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ДокОснование.Субконто1;
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = ДокОснование.Субконто2;
//		Если ДокОснование.СчетКт = ПланыСчетов.Учетный.ТМЦИнв Тогда
//			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = ДокОснование.Субконто3;
//		КонецЕсли;
//		
//		//траты на 90.3
//		Если ДокОснование.ТратыНалива Или ДокОснование.ТратыНаливаКРХ Тогда
//			Движение = Движения.Учетный.Добавить();
//			Движение.СчетДт = ПланыСчетов.Учетный.Счет9004();
//			Движение.СчетКт = ДокОснование.СчетКт;
//			Если ДокОснование.СчетКт.УчетПоПодразделениям Тогда
//				Движение.ПодразделениеКт = ДокОснование.ВидДеятельности;
//			КонецЕсли;
//			Движение.Период = Дата;
//			Движение.Предприятия = Предприятие;
//			Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//			Движение.Сумма = -ДокОснование.ТратыНалива * Себестоимость;
//			Движение.КоличествоКт = -ДокОснование.ТратыНалива;
//			Если ДокОснование.СчетКт.Крахмал Тогда
//				Движение.КоличествоКРХКт = -ДокОснование.ТратыНаливаКРХ;				
//			КонецЕсли;
//			Движение.НомерСтрокиДок = 1;
//		Движение.Содержание = "Сторно " + ДокОснование;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ДокОснование.Субконто1;
//			//Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Статьи затрат", Истина)] = Справочники.ИздержкиОбращения.СписаниеТраты;
//			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Материалы] = ДокОснование.Субконто1;
//			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = ДокОснование.Субконто2;
//		КонецЕсли;
//		
//		
//	ИначеЕсли  ТипЗнч(ДокОснование.Субконто1) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
//		//выручка
//		Движение = Движения.Учетный.Добавить();
//		Если ДокОснование.Флаг60_79 = 0 Тогда
//			Движение.СчетДт = ДокОснование.Счет;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина)] = ДокОснование.Контрагент;
//		Иначе
//			Движение.СчетДт = ПланыСчетов.Учетный.Счет7902();
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Предприятия", Истина)] = ДокОснование.ПредприятиеПоставщик;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Внутренние договоры", Истина)] = ДокОснование.ДоговорВн;
//		КонецЕсли;
//		Движение.СчетКт = ПланыСчетов.Учетный.Счет9005();
//		Движение.Период = Дата;
//		Движение.Предприятия = Предприятие;
//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//		Движение.Сумма = -ДокОснование.СуммаОтгрузки;
//		Движение.НомерСтрокиДок = 1;
//		Движение.Содержание = "Сторно " + ДокОснование;
//		//Если Счет = ПланыСчетов.Учетный.Счет6201() Тогда
//		//	Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина)] = Договор;			
//		//КонецЕсли;
//		
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Основные средства", Истина)] = ДокОснование.Субконто1;
//		
//		//себестоимость
//		Выборка = РезультатСебест.Выбрать();
//		СтрукутраПоиска = Новый Структура("Субконто1, Счет, Субконто2", ДокОснование.Субконто1, ПланыСчетов.Учетный.Счет01(), ДокОснование.Субконто2) ;
//		Если Выборка.НайтиСледующий(СтрукутраПоиска) Тогда
//			Себестоимость = ?(Выборка.КоличествоОстаток, Выборка.СуммаОстаток / Выборка.КоличествоОстаток, 0);
//		Иначе
//			Себестоимость = 0;
//		КонецЕсли;
//		Движение = Движения.Учетный.Добавить();
//		Движение.СчетДт = ПланыСчетов.Учетный.Счет9005();
//		Движение.СчетКт = ПланыСчетов.Учетный.Счет01();
//		Движение.Период = Дата;
//		Движение.Предприятия = ДокОснование.Предприятие;
//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//		Движение.Сумма = -Себестоимость * ДокОснование.Количество;
//		Движение.КоличествоКт = -ДокОснование.Количество;
//		Движение.НомерСтрокиДок = 1;
//		Движение.Содержание = "Сторно " + ДокОснование;
//		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Основные средства", Истина)] = ДокОснование.Субконто1;
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Основные средства", Истина)] = ДокОснование.Субконто1;
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = ДокОснование.Субконто2;
//		
//		
//	Иначе //спирт
//		
//		//выручка
//		Движение = Движения.Учетный.Добавить();
//		Если ДокОснование.Флаг60_79 = 0 Тогда
//			Движение.СчетДт = ДокОснование.Счет;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина)] = ДокОснование.Контрагент;
//			Если ДокОснование.Счет = ПланыСчетов.Учетный.Счет6201() Тогда
//				Движение.ПодразделениеДт = ДокОснование.ВидДеятельности;
//				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина)] = ДокОснование.Договор;
//			КонецЕсли;
//		Иначе
//			Движение.СчетДт = ПланыСчетов.Учетный.Счет7902();
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Предприятия", Истина)] = ДокОснование.ПредприятиеПоставщик;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Внутренние договоры", Истина)] = ДокОснование.ДоговорВн;
//		КонецЕсли;
//		Движение.СчетКт = ПланыСчетов.Учетный.Счет9001();
//		Движение.ПодразделениеКт = ДокОснование.ВидДеятельности;
//		Движение.Период = Дата;
//		Движение.Предприятия = Предприятие;
//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//		Движение.Сумма = -ДокОснование.СуммаОтгрузки;
//		Движение.НомерСтрокиДок = 1;
//		Движение.Содержание = "Сторно " + ДокОснование;
//		//Если Счет = ПланыСчетов.Учетный.Счет6201() Тогда
//		//	Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина)] = Договор;
//		//Конецесли;
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ДокОснование.Субконто1;
//		
//		//себестоимость
//		
//		Если ДокОснование.СчетКт = ПланыСчетов.Учетный.Счет41() Тогда
//			СчетГП = ПланыСчетов.Учетный.Счет41();
//			Выборка = РезультатСебест.Выбрать();
//			СтрукутраПоиска = Новый Структура("Субконто1, Счет, Субконто2", ДокОснование.Субконто1, СчетГП, ДокОснование.Субконто2) ;
//			Если Выборка.НайтиСледующий(СтрукутраПоиска) Тогда
//				Себестоимость = ?(Выборка.КоличествоОстаток, Выборка.СуммаОстаток / Выборка.КоличествоОстаток, 0);
//			Иначе
//				Себестоимость = 0;
//			КонецЕсли;
//		Иначе
//			СчетГП = ПланыСчетов.Учетный.Счет43();
//			
//			//запрос на плановую сеьестоимость
//			Запрос = Новый Запрос;
//			Запрос.Текст = "ВЫБРАТЬ
//			|	ПлановаяСебестоимостьСрезПоследних.Номенклатура,
//			|	ПлановаяСебестоимостьСрезПоследних.Сумма
//			|ИЗ
//			|	РегистрСведений.ПлановаяСебестоимость.СрезПоследних(&Дата, Номенклатура = &Номенклатура) КАК ПлановаяСебестоимостьСрезПоследних";
//			
//			Запрос.УстановитьПараметр("Дата", Дата);
//			Запрос.УстановитьПараметр("ТекПредприятие", Предприятие);
//			Запрос.УстановитьПараметр("Номенклатура", ДокОснование.Субконто1);
//			
//			РезультатРегистр = Запрос.Выполнить();
//			Выборка = РезультатРегистр.Выбрать();
//			Если Выборка.Следующий() Тогда
//				Себестоимость = Выборка.Сумма;
//			Иначе
//				Себестоимость = 0;			
//			КонецЕсли;
//		КонецЕсли;
//		
//		Движение = Движения.Учетный.Добавить();
//		Движение.СчетДт = ПланыСчетов.Учетный.Счет9002();
//		Движение.ПодразделениеДт = ДокОснование.ВидДеятельности;
//		Движение.СчетКт = СчетГП;
//		Если СчетГП.УчетПоПодразделениям Тогда
//			Движение.ПодразделениеКт = ДокОснование.ВидДеятельности;
//		КонецЕсли;
//		Движение.Период = Дата;
//		Движение.Предприятия = Предприятие;
//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//		Движение.Сумма = -Себестоимость * ДокОснование.Количество;
//		Движение.КоличествоКт = -ДокОснование.Количество;
//		Движение.НомерСтрокиДок = 1;
//		Движение.Содержание = "Сторно " + ДокОснование;
//		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ДокОснование.Субконто1;
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ДокОснование.Субконто1;
//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = ДокОснование.Субконто2;
//		
//		//////////////////////////////начисление и возмещение////////////////////////////////////
//		Для каждого ТекСтрока Из ДокОснование.НачислениеДоставки Цикл
//			
//			//начисление
//			Если ТекСтрока.СуммаДоставкиНачислено Тогда
//				Движение = Движения.Учетный.Добавить();
//				Движение.СчетДт = ПланыСчетов.Учетный.Счет9003();
//				Движение.СчетКт = ТекСтрока.КорСчет;
//				Движение.Период = Дата;
//				Движение.Предприятия = Предприятие;
//				Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//				Движение.ПодразделениеДт = ДокОснование.ВидДеятельности;
//				Движение.Сумма = - ТекСтрока.СуммаДоставкиНачислено;
//				Если ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.ТранспортныеЖд Тогда
//					Движение.Содержание = "Кол-во: " + Строка(ДокОснование.Количество) + " дал, Расстояние: " + Строка(ТекСтрока.Расстояние) + " км, № цистерны: " + Строка(ТекСтрока.НомерЦистерны) + ", Грузополучатель: " + Строка(ДокОснование.Контрагент) + "
//					|" + ТекСтрока.Основание;
//				ИначеЕсли ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.ТранспортныеАвто Тогда
//					Движение.Содержание = "Кол-во: " + Строка(ДокОснование.Количество) + " дал, Расстояние: " + Строка(ТекСтрока.Расстояние) + " км, № машины: " + Строка(ТекСтрока.НомерЦистерны) + ", Грузополучатель: " + Строка(ДокОснование.Контрагент) + "
//					|" + ТекСтрока.Основание;
//				ИначеЕсли ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.Бонусы Тогда
//					Движение.Содержание = "Кол-во: " + Строка(ДокОснование.Количество) + " дал, Бонус: " + Строка(ТекСтрока.ДоставкаНачислено) + ", Грузополучатель: " + Строка(ДокОснование.Контрагент) + "
//					|" + ТекСтрока.Основание;
//				ИначеЕсли ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.Верхи Тогда
//					Движение.Содержание = "Кол-во: " + Строка(ДокОснование.Количество) + " дал, Верх: " + Строка(ТекСтрока.ДоставкаНачислено) + ", Грузополучатель: " + Строка(ДокОснование.Контрагент) + "
//					|" + ТекСтрока.Основание;
//				Иначе
//					Движение.Содержание = "Кол-во: " + Строка(ДокОснование.Количество) + " дал, На ед: " + Строка(ТекСтрока.ДоставкаНачислено) + ", Грузополучатель: " + Строка(ДокОснование.Контрагент) + "
//					|" + ТекСтрока.Основание;
//				КонецЕсли;
//				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Статьи затрат", Истина)] = ТекСтрока.ВидДоставки;
//				Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ДокОснование.Субконто1;
//				
//				Если ТекСтрока.КорСчет.УчетПоПодразделениям Тогда
//					Движение.ПодразделениеКт = ДокОснование.ВидДеятельности;	
//				КонецЕсли;
//				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,ТекСтрока.КорСчет,1,ТекСтрока.КорСубконто1);
//				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,ТекСтрока.КорСчет,2,ТекСтрока.КорСубконто2);
//				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,ТекСтрока.КорСчет,3,ТекСтрока.КорСубконто3);
//			КонецЕсли;
//			
//			//возмещение
//			Если ТекСтрока.СуммаДоставкиВозмещено Тогда
//				Движение = Движения.Учетный.Добавить();
//				Если ДокОснование.Флаг60_79 = 0 Тогда
//					Движение.СчетДт = ДокОснование.Счет;
//					Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Контрагенты", Истина)] = ДокОснование.Контрагент;
//					Если ДокОснование.Счет = ПланыСчетов.Учетный.Счет6201() Тогда
//						Движение.ПодразделениеДт = ДокОснование.ВидДеятельности;
//						Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Договоры", Истина)] = ДокОснование.Договор;
//					КонецЕсли;
//				Иначе
//					Движение.СчетДт = ПланыСчетов.Учетный.Счет7902();
//					Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Предприятия", Истина)] = ДокОснование.ПредприятиеПоставщик;
//					Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Внутренние договоры", Истина)] = ДокОснование.ДоговорВн;
//				КонецЕсли;
//				Движение.СчетКт = ПланыСчетов.Учетный.Счет9003();
//				Движение.ПодразделениеКт = ДокОснование.ВидДеятельности;
//				Движение.Период = Дата;
//				Движение.Предприятия = Предприятие;
//				Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//				Движение.Сумма = -ТекСтрока.СуммаДоставкиВозмещено;
//				Движение.НомерСтрокиДок = 1;
//				Движение.Содержание =  "Возмещение: " + ?(ДокОснование.Флаг60_79, "", Строка(ДокОснование.Контрагент)) + ", Кол-во:" + ДокОснование.Количество + " На ед:" + ТекСтрока.ДоставкаВозмещено;
//				Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Статьи затрат", Истина)] = ТекСтрока.ВидДоставки;
//				Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ДокОснование.Субконто1;
//			КонецЕсли;
//			
//			
//		КонецЦикла;
//		
//		//траты на 90.3
//		Если ДокОснование.ТратыНалива Тогда
//			Движение = Движения.Учетный.Добавить();
//			Движение.СчетДт = ПланыСчетов.Учетный.Счет9003();
//			Движение.ПодразделениеДт = ДокОснование.ВидДеятельности;
//			Движение.СчетКт = ДокОснование.СчетКт;
//			Если ДокОснование.СчетКт.УчетПоПодразделениям Тогда
//				Движение.ПодразделениеКт = ДокОснование.ВидДеятельности;
//			КонецЕсли;
//			Движение.Период = Дата;
//			Движение.Предприятия = Предприятие;
//			Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
//			Движение.Сумма = -ДокОснование.ТратыНалива * Себестоимость;
//			Движение.КоличествоКт = -ДокОснование.ТратыНалива;
//			Движение.НомерСтрокиДок = 1;
//			Движение.Содержание = "Сторно " + ДокОснование;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ДокОснование.Субконто1;
//			Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Статьи затрат", Истина)] = Справочники.ИздержкиОбращения.СписаниеТраты;
//			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Номенклатура", Истина)] = ДокОснование.Субконто1;
//			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = ДокОснование.Субконто2;
//		КонецЕсли;
//		

//		//Движения по регистру Реализация
//		
//		Движение = Движения.Реализация.Добавить();
//		Движение.Период = Дата;
//		Движение.Предприятие = Предприятие;
//		Движение.Контрагент = ?(ДокОснование.Флаг60_79 = 0,ДокОснование.Контрагент,ДокОснование.ПредприятиеПоставщик);
//		Движение.Номенклатура = ДокОснование.Субконто1;
//		Движение.Количество = -ДокОснование.Количество;
//		Движение.КоличествоОбъем = -ДокОснование.КоличествоКРХ;
//		Движение.СуммаОтгрузки = -ДокОснование.СуммаОтгрузки;
//		
//		//считаем начисления и возмещения
//		СуммаЖД = 0;
//		СуммаАвто = 0;
//		СуммаВозмещениеДоставки = 0;
//		СуммаВерха = 0;
//		СуммаВерхаМенеджера = 0;
//		Прочее = 0;
//		Расстояние = 0;
//		Для каждого ТекСтрока Из ДокОснование.НачислениеДоставки Цикл
//			Если ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.ТранспортныеЖд Тогда
//				СуммаЖД = СуммаЖД + ТекСтрока.СуммаДоставкиНачислено;
//				СуммаВозмещениеДоставки = СуммаВозмещениеДоставки + ТекСтрока.СуммаДоставкиВозмещено; 
//				Движение.НомерЦистерны = ТекСтрока.НомерЦистерны;
//			ИначеЕсли ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.ТранспортныеАвто Тогда
//				СуммаАвто = СуммаАвто + ТекСтрока.СуммаДоставкиНачислено;
//				СуммаВозмещениеДоставки = СуммаВозмещениеДоставки + ТекСтрока.СуммаДоставкиВозмещено;
//				Движение.НомерМашины = ТекСтрока.НомерЦистерны;
//			ИначеЕсли ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.Верхи Тогда
//				СуммаВерха = СуммаВерха + ТекСтрока.СуммаДоставкиНачислено;
//			ИначеЕсли ТекСтрока.ВидДоставки = Справочники.ИздержкиОбращения.Верхи Тогда
//				СуммаВерхаМенеджера = СуммаВерхаМенеджера + ТекСтрока.СуммаДоставкиНачислено;
//			Иначе
//				 Прочее = Прочее + ТекСтрока.СуммаДоставкиНачислено;
//			КонецЕсли;
//			 Расстояние = Расстояние + ТекСтрока.Расстояние;
//		КонецЦикла;
//		
//		Движение.Километраж = -Расстояние;
//		Движение.СуммаТранспортНачисленоАвто = -СуммаАвто;
//		Движение.СуммаТранспортНачисленоЖд = -СуммаЖД;
//		Движение.СуммаТранспорт = -СуммаВозмещениеДоставки;		
//		Движение.СуммаВерх = -СуммаВерха;
//		Движение.СуммаМенеджер = -СуммаВерхаМенеджера;
//		
//		Если ДокОснование.СчетКт = ПланыСчетов.Учетный.Счет41() Тогда
//			СчетТов = ПланыСчетов.Учетный.Счет41();
//			Выборка = РезультатСебест.Выбрать();
//			СтрукутраПоиска = Новый Структура("Субконто1, Счет, Субконто2", ДокОснование.Субконто1, СчетТов, ДокОснование.Субконто2) ;
//			Если Выборка.НайтиСледующий(СтрукутраПоиска) Тогда
//				Себестоимость = ?(Выборка.КоличествоОстаток, Выборка.СуммаОстаток / Выборка.КоличествоОстаток, 0);
//			Иначе
//				Себестоимость = 0;
//			КонецЕсли;
//			Движение.Себестоимость = -Себестоимость * ДокОснование.Количество;
//		КонецЕсли;
//		Движение.Себестоимость = -Себестоимость * ДокОснование.Количество;
//		
//		КомДир = РегистрыСведений.КоммерческиеДиректоры.СрезПоследних(Дата,Новый Структура("Контрагент",ДокОснование.Контрагент));
//		Если КомДир.Количество() Тогда
//			Движение.КоммерческийДиректор = КомДир[0].КоммерческийДиректор;			
//		КонецЕсли;
//		Менеджер = РегистрыСведений.Ответственные.СрезПоследних(Дата,Новый Структура("Контрагент",ДокОснование.Контрагент));
//		Если Менеджер.Количество() Тогда
//			Движение.Менеджер = Менеджер[0].Ответственный;			
//		КонецЕсли;
//		
//	КонецЕсли;

//	

//КонецПроцедуры
