﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.РеализацияКоличествоКРХ.ТолькоПросмотр = Истина;
	ВидимостьГрупп();
	СчетПриИзменении(0);
	ЗаголовокКоличество();
	ФлагВалютыПриИзменении("")
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовокКоличество()
	Если Объект.Товары.Количество() Тогда		
		
		Если Счет4341(Объект.Товары[0].Счет) Тогда
			Элементы.РеализацияКоличествоКРХ.Заголовок = "Количество по об.";
		//ИначеЕсли Объект.Товары[0].Счет= Счет101() Тогда
		//	Элементы.РеализацияКоличествоКРХ.Заголовок = "Количество КРХ";
		Иначе
			Элементы.РеализацияКоличествоКРХ.Заголовок = " ";
		КонецЕсли;
	Иначе
		Элементы.РеализацияКоличествоКРХ.Заголовок = " ";		
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ВерхиВерхКонтрагентаПриИзменении(Элемент)
	Если НЕ ТипЗнч(Элементы.Верхи.ТекущиеДанные.ВерхКонтрагента) = Тип("СправочникСсылка.Сотрудники") Тогда
		Элементы.Верхи.ТекущиеДанные.Сумма = БюджетныйНаСервере.ВернутьРеквизит(Элементы.Верхи.ТекущиеДанные.Верхконтрагента, "СтавкаВерха"); 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура РассчитатьОстаткиСервер(Наименование, Счет, Склад)
	//запрос на среднюю себестоимость по товарам
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕСТЬNULL(УчетныйОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	               |	ЕСТЬNULL(УчетныйОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток,
	               |	УчетныйОстатки.Субконто1,
	               |	УчетныйОстатки.Счет,
	               |	УчетныйОстатки.Субконто2
	               |ИЗ
	               |	РегистрБухгалтерии.Учетный.Остатки(
	               |			&Дата,
	               |			Счет В ИЕРАРХИИ (&Счет),
	               |			,
	               |			Предприятия В ИЕРАРХИИ (&Предприятия)
	               |				И СценарийПлана = &СценарийПлана
	               |				И Субконто2 = &Склад) КАК УчетныйОстатки";
	
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет41());//товары
	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет43());//ГП
	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет10());//сырье
	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет01());//ОС
	
	Запрос.УстановитьПараметр("Дата", ?(Объект.Ссылка.Пустая(), ТекущаяДата(), Объект.Дата));
	Запрос.УстановитьПараметр("Предприятия", Объект.Предприятие);
	Запрос.УстановитьПараметр("Счет", МассивСчетов);
	Запрос.УстановитьПараметр("СценарийПлана", Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина));
	Запрос.УстановитьПараметр("Склад", Склад);
	
	РезультатСебест = Запрос.Выполнить();
	
	Выборка = РезультатСебест.Выбрать();
	
	СтруктураПоиска = Новый Структура("Субконто1, Счет", Наименование, Счет);
	
	Если Выборка.НайтиСледующий(СтруктураПоиска) Тогда
		
		Остаток = Выборка.КоличествоОстаток;
		Сумма = Выборка.СуммаОстаток;
		Цена = ?(Выборка.КоличествоОстаток, Выборка.СуммаОстаток / Выборка.КоличествоОстаток, 0);		
	
	КонецЕсли;
	

КонецПроцедуры
 

&НаКлиенте
Процедура РасчитатьОстатки(Команда)
	Если Объект.Реализация.Количество() Тогда
		Элементы.Группа8.Заголовок = "Остатки на складе: " + Строка(Элементы.Реализация.ТекущиеДанные.Склад);
		РассчитатьОстаткиСервер(Элементы.Реализация.ТекущиеДанные.Наименование, Элементы.Реализация.ТекущиеДанные.Счет, Элементы.Реализация.ТекущиеДанные.Склад);	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция Счет101()
	Возврат ПланыСчетов.Учетный.Счет1001();
КонецФункции // ()

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	Если Объект.Договор.Пустая() Тогда
		Объект.Договор = БюджетныйНаСервере.ВернутьРеквизит(Объект.Контрагент, "ДоговорПоУмолчанию");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РеализацияСчетПриИзменении(Элемент)
	Если Элементы.Реализация.ТекущиеДанные.Счет = Счет101() Тогда
		Элементы.РеализацияКоличествоКРХ.ТолькоПросмотр = Ложь;
		//Элементы.ТратыНаливаКРХ.Доступность = Истина;
	ИначеЕсли Счет4341(Элементы.Реализация.ТекущиеДанные.Счет) Тогда
		Элементы.РеализацияКоличествоКРХ.ТолькоПросмотр = Ложь;
	Иначе
		Элементы.РеализацияКоличествоКРХ.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если НЕ Элементы.Реализация.ТекущиеДанные.Счет = ВернутьИнвСчет() Тогда
		Элементы.РеализацияВнеобАктивы.ТолькоПросмотр = Истина;
	Иначе
		Элементы.РеализацияВнеобАктивы.ТолькоПросмотр = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция Счет4341(ТекСчет)
	Возврат ТекСчет = ПланыСчетов.Учетный.Счет43() ИЛИ ТекСчет = ПланыСчетов.Учетный.Счет41();
КонецФункции // ()

&НаСервереБезКонтекста
Функция ВернутьИнвСчет()
	Возврат ПланыСчетов.Учетный.НайтиПоКоду("10.05");
КонецФункции // ()


&НаКлиенте
Процедура ВидимостьГрупп()
	//Если Объект.Флаг60_79 = 0 Тогда
	//	Элементы.ГруппаВнутрихолдинговая.Видимость = Ложь;
	//	Элементы.ГруппаКонтрагента.Видимость = Истина;
	//	Элементы.Счет.ПараметрыВыбора = УЧ_Сервер.ПолучитьПараметрыВыбораСчета("62");
	//ИначеЕсли Объект.Флаг60_79 = 2 Тогда
	//	Элементы.ГруппаВнутрихолдинговая.Видимость = Ложь;
	//	Элементы.ГруппаКонтрагента.Видимость = Истина;
	//	Элементы.Счет.ПараметрыВыбора = УЧ_Сервер.ПолучитьПараметрыВыбораСчета("60");
	//Иначе
		//Элементы.ГруппаВнутрихолдинговая.Видимость = Истина;
		Элементы.ГруппаКонтрагента.Видимость = Истина;
	//КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Флаг60_79ПриИзменении(Элемент)
	Объект.Счет = "";
	ВидимостьГрупп();	
КонецПроцедуры


&НаКлиенте
Процедура ДоставкаСуммаПриИзменении(Элемент)
	Если Объект.ДоставкаНаЕдиницу Тогда
		Элементы.РеализацияДоставка.Заголовок = "Доставка (на ед.)";
	Иначе
		Элементы.РеализацияДоставка.Заголовок = "Доставка";
	КонецЕсли;
	//Для каждого ТекСтрока Из Объект.Реализация Цикл
	//	Если Объект.ДоставкаНаЕдиницу Тогда
	//		ТекСтрока.Сумма = ТекСтрока.Количество * (ТекСтрока.Цена + ТекСтрока.Доставка);	
	//	Иначе
	//		ТекСтрока.Сумма = ТекСтрока.Количество * (ТекСтрока.Цена) + ТекСтрока.Доставка;
	//	КонецЕсли;	
	//КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция СтатьяВерх()
	Возврат Справочники.СтатьиЗатрат.Верхи;
КонецФункции // ()

&НаКлиенте
Процедура ПодразделениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//БюджетныйНаКлиенте.НачалоВыбораПодразделения(Объект.Счет, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СчетПриИзменении(Элемент)
	
	БюджетныйНаКлиенте.НазначитьСубконто(Элементы, ЭтаФорма, "Контрагент", "Договор",, Объект.Счет, , , НЕ Элемент = Неопределено);

КонецПроцедуры

&НаСервере
Функция ПолучитьСубконто(НомерСубконто)
	Если НомерСубконто > Объект.Счет.ВидыСубконто.Количество() Тогда
		Возврат "";
	Иначе
		Возврат Объект.Счет.ВидыСубконто[НомерСубконто - 1].ВидСубконто.Наименование;			
	КонецЕсли;
КонецФункции // ()

&НаКлиенте
Процедура ВерхиДоговорМенеджераНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если НЕ ТипЗнч(Элементы.Верхи.ТекущиеДанные.ВерхКонтрагента) = Тип("СправочникСсылка.Сотрудники") Тогда
		СтандартнаяОбработка = Ложь;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура РеализацияКоличествоПриИзменении(Элемент)

	ТекДанные = Элементы.Реализация.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		
		Если Элементы.Реализация.ТекущиеДанные.Доставка Тогда
			Элементы.Реализация.ТекущиеДанные.СуммаДоставки = Элементы.Реализация.ТекущиеДанные.Количество * Элементы.Реализация.ТекущиеДанные.Доставка;	
		КонецЕсли;
		
		сабОбщегоНазначенияБУХКлиентСервер.ПриИзмененииКоличествоЦена(ЭтаФорма, "Реализация");
		Если Элементы.Реализация.ТекущиеДанные.Цена Тогда
			Элементы.Реализация.ТекущиеДанные.СуммаОтгрузки = Элементы.Реализация.ТекущиеДанные.Количество * Элементы.Реализация.ТекущиеДанные.Цена;	
		КонецЕсли;
		
		
		//Если РежимСканирования Тогда
		//	ПодобратьНоменклатуруПоШК(Неопределено);
		//КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьСумму(ТекДанные = Неопределено, ИмяТЧ = Неопределено, ПересчитыватьСумму = Истина)
	
	Если ТекДанные = Неопределено Тогда
		ТекДанные = Элементы.Реализация.ТекущиеДанные;
	КонецЕсли;
	Если ИмяТч = Неопределено Тогда
		ИмяТЧ = "Товары";
	КонецЕсли;
	
	Если Не ТекДанные = Неопределено Тогда
		Если ПересчитыватьСумму Тогда
			ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
			ТекДанные.СуммаОтгрузки = ТекДанные.Сумма;
		КонецЕсли; 
		ОбработкаТабличныхЧастейКлиентСервер.ПриИзмененииКоличествоЦена(ЭтаФорма, ИмяТЧ);
	КонецЕсли;	
	
КонецПроцедуры	

&НаКлиенте
Процедура РеализацияЦенаПриИзменении(Элемент)
	сабОбщегоНазначенияБУХКлиентСервер.ПриИзмененииКоличествоЦена(ЭтаФорма, "Реализация");
	Элементы.Реализация.ТекущиеДанные.СуммаОтгрузки = Элементы.Реализация.ТекущиеДанные.Сумма;
КонецПроцедуры
&НаКлиенте
Процедура РеализацияСуммаПриИзменении(Элемент)
	//ТекКоличество = Элементы.Реализация.ТекущиеДанные.Количество;
	//Элементы.Реализация.ТекущиеДанные.Цена = ?(ТекКоличество, Элементы.Реализация.ТекущиеДанные.СуммаОтгрузки / ТекКоличество, 0);
	
	Если Объект.СуммаВключаетНДС Тогда
		Элементы.Реализация.ТекущиеДанные.Сумма = Элементы.Реализация.ТекущиеДанные.СуммаОтгрузки;
		сабОбщегоНазначенияБУХКлиентСервер.ПриИзмененииСумма(ЭтаФорма, "Реализация");
	Иначе
		ТекущиеДанные = Элементы.Реализация.ТекущиеДанные;
		ТекущиеДанные.Сумма = ТекущиеДанные.СуммаОтгрузки * 100 / (100 + БюджетныйНаСервере.ВернутьРеквизит(ТекущиеДанные.СтавкаНДС, "Ставка"));
		сабОбщегоНазначенияБУХКлиентСервер.ПриИзмененииСумма(ЭтаФорма, "Реализация");
	КонецЕсли;
	
	//Объект.СуммаНаличногоРасчета = Объект.Товары.Итог("СуммаОтгрузки") - Объект.ОплатаПлатежнымиКартами.Итог("Сумма");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	ДокОбъект = Объект.Ссылка.ПолучитьОбъект();
	ДокОбъект.Товары.Очистить();
	ДокОбъект.Заполнить(Объект.ДокОснование);
	ЭтаФорма.ЗначениеВРеквизитФормы(ДокОбъект,"Объект");
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
	 ЗаполнитьНаСервере();
 КонецПроцедуры

&НаКлиенте
 Процедура ПредприятиеПриИзменении(Элемент)
	ПредприятиеПриИзмененииНаСервере();
	ПараметрыВыбораСтатьи = УЧ_Сервер.ПолучитьПараметрыВыбораСтатьиЗатрат(Объект.Предприятие, Элементы.ВерхиСтатья.ПараметрыВыбора);
	Элементы.ВерхиСтатья.ПараметрыВыбора = ПараметрыВыбораСтатьи;
КонецПроцедуры

&НаСервере
Процедура ПредприятиеПриИзмененииНаСервере()
	сабОбщегоНазначенияКлиентСервер.СкрытьПодразделения(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
 Процедура РеализацияСчетОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	 Если Счет4341(ВыбранноеЗначение) Тогда
		 Элементы.РеализацияКоличествоКРХ.Заголовок = "Количество по об.";
	 ИначеЕсли ВыбранноеЗначение= Счет101() Тогда
		 Элементы.РеализацияКоличествоКРХ.Заголовок = "Количество КРХ";
	 Иначе
		 Элементы.РеализацияКоличествоКРХ.Заголовок = " ";
	 КонецЕсли;
	 Элементы.Реализация.ТекущиеДанные.Счет = ВыбранноеЗначение;
	 
 КонецПроцедуры

&НаКлиенте
 Процедура РеализацияПриАктивизацииСтроки(Элемент)
	 Если НЕ Элементы.Реализация.ТекущиеДанные = Неопределено Тогда
		 РеализацияСчетПриИзменении(0);	
	 КонецЕсли;
	 
 КонецПроцедуры

&НаКлиенте
 Процедура ФлагВалютыПриИзменении(Элемент)
	 	Элементы.ГруппаВалюты.Видимость = Объект.ФлагВалюты;
 КонецПроцедуры

&НаКлиенте
 Процедура ВалютаПриИзменении(Элемент)
	 	Объект.Курс = БюджетныйНаСервере.ТекущийКурс(Объект.Валюта,Объект.Дата,Объект.Предприятие);
 КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Счет = ПланыСчетов.Учетный.Счет6201();
		Объект.ВидОперации = "Возврат";
	КонецЕсли;	
	
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	
	ЗаполнитьАртикул();
	
	ИспользоватьСерии = Справочники.СерииНоменклатуры.СерииНоменклатурыИспользуются();
	
	//синхронизация серий
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
		сабОперОбщегоНазначения.СинхронизацияСерийПриСозданииФормы(Объект.Товары,Объект.СерииНоменклатуры);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	сабОбщегоНазначения.ОтобразитьСостояниеДокумента(ЭтаФорма, ТекущийОбъект); 
	
	//Синхронизация серий
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда 
		ДокументСоздан = Истина;
		ТекстОшибки = "";
		сабОперОбщегоНазначения.СинхронизацияСерийПриЗаписиНаСервереФормы(ПараметрыЗаписи,ЭтотОбъект,ТекущийОбъект,Отказ,ДокументСоздан,ТекстОшибки);
		Если Не ДокументСоздан Тогда
			Сообщить("Табличная часть ""Серии номенклатуры"" не была синхронизирована с документом " + ЭтотОбъект.ДокументБУ + ". По причине: " + ТекстОшибки);
        КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РеализацияНаименованиеПриИзменении(Элемент)
	
	ТекДанные = Элементы.Реализация.ТекущиеДанные;
	
	Если Не ТекДанные = Неопределено Тогда
		СтруктураВозврата = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.Номенклатура, "СтавкаНДС, Счет10, ЕдиницаИзмерения");
		ТекДанные.СтавкаНДС = СтруктураВозврата.СтавкаНДС;	
		ТекДанные.Счет = СтруктураВозврата.Счет10;
		ТекДанные.Склад = БюджетныйНаСервере.ВернутьРеквизит(Объект.Подразделение, "Склад");
		ТекДанные.ЕдиницаИзмерения = СтруктураВозврата.ЕдиницаИзмерения;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" Тогда
		Если Параметр.Свойство("ФормаВладелецУИД") И Параметр.ФормаВладелецУИД = ЭтаФорма.УникальныйИдентификатор Тогда
			сабОбщегоНазначения.ПрикрепитьФайлКДокументу(Параметр); 
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПодразделениеПриИзмененииНаСервере()

	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		РеквизитыПодразделения = БюджетныйНаСервере.ВернутьРеквизиты(Объект.Подразделение, "Организация");
		Объект.Организация = РеквизитыПодразделения.Организация;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	ПодразделениеПриИзмененииНаСервере();
КонецПроцедуры
 
#Область ПодборТоваров

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Обработка.ПодборНоменклатуры.Форма.Форма" Тогда
		ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИсточникВыбора.ИмяТаблицы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодборТовары(Команда)

	ПараметрыПодбора = ПолучитьПараметрыПодбора("Товары");
	Если ПараметрыПодбора <> Неопределено Тогда
		ОткрытьФорму("Обработка.ПодборНоменклатуры.Форма.Форма", ПараметрыПодбора,
			ЭтаФорма, УникальныйИдентификатор);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораПодборВставкаИзБуфераНаСервере(ВыбранноеЗначение, ИмяТаблицы)

	ЭтоВставкаИзБуфера = ВыбранноеЗначение.Свойство("ЭтоВставкаИзБуфера");
	СписокСвойств = Неопределено;
	Если ЭтоВставкаИзБуфера Тогда
		
		ТаблицаТоваров = ВыбранноеЗначение.Данные;
		СписокСвойств = ВыбранноеЗначение.СписокСвойств;
		
	Иначе
		
		ТаблицаТоваров = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресПодобраннойНоменклатурыВХранилище);
		
	КонецЕсли;
	
	ДанныеОбъекта = Новый Структура("Дата, Организация, Склад");
	ЗаполнитьЗначенияСвойств(ДанныеОбъекта, Объект);
	
	ЗаполнитьСтавкиНДСВРознице = Ложь;
	
	СтрокиДляЗаполненияСчетов = Новый Массив;
	
	Для каждого СтрокаТовара Из ТаблицаТоваров Цикл
		
		СведенияОНоменклатуре = БюджетныйНаСервере.ВернутьРеквизиты(СтрокаТовара.Номенклатура, "ЕдиницаИзмерения, Счет10, СтавкаНДС");
		СтрокаТабличнойЧасти = Объект[ИмяТаблицы].Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, СтрокаТовара, СписокСвойств);
		СтрокиДляЗаполненияСчетов.Добавить(СтрокаТабличнойЧасти);
		Если СведенияОНоменклатуре = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		//СтрокаТабличнойЧасти.СчетУчета		= ?(ЗначениеЗаполнено(СтрокаТабличнойЧасти.СчетУчета),
		//СтрокаТабличнойЧасти.СчетУчета, СведенияОНоменклатуре.Счет10);
	КонецЦикла;
	
	
	
	Если ЭтоВставкаИзБуфера Тогда
		
		ВыбранноеЗначение.КоличествоДобавленныхСтрок = СтрокиДляЗаполненияСчетов.Количество();
		
	КонецЕсли;
	

	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыПодбора(ИмяТаблицы)

	ДатаРасчетов		= ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()),ТекущаяДата(), Объект.Дата);
	
	ЗаголовокПодбора	= НСтр("ru = 'Подбор номенклатуры в %1 (%2)'");
	Если ИмяТаблицы = "Товары" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Товары'");
	ИначеЕсли ИмяТаблицы = "ВозвратнаяТара" Тогда
		ПредставлениеТаблицы = НСтр("ru = 'Возвратная тара'");
	КонецЕсли;
	ЗаголовокПодбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ЗаголовокПодбора, Объект.Ссылка, ПредставлениеТаблицы);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаРасчетов"  , ДатаРасчетов);
	ПараметрыФормы.Вставить("Валюта"        , ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета());
	ПараметрыФормы.Вставить("Организация"   , Объект.Организация);
	ПараметрыФормы.Вставить("Подразделение" , Объект.Подразделение);
	ПараметрыФормы.Вставить("Заголовок"     , ЗаголовокПодбора);
	ПараметрыФормы.Вставить("ВидПодбора"    , "");
	ПараметрыФормы.Вставить("ИмяТаблицы"    , ИмяТаблицы);
	ПараметрыФормы.Вставить("Услуги"        , ИмяТаблицы = "Услуги");
	ПараметрыФормы.Вставить("ПоказыватьОстатки"  , Истина);
	ПараметрыФормы.Вставить("ЕстьКоличество", Истина);
	ПараметрыФормы.Вставить("Предприятие" , Объект.Предприятие);
	
	Возврат ПараметрыФормы;

КонецФункции

#КонецОбласти 
 
&НаКлиенте
Процедура РеализацияСтавкаНДСПриИзменении(Элемент)
	сабОбщегоНазначенияБУХКлиентСервер.ПриИзмененииСтавкаНДС(ЭтаФорма, "Товары");
КонецПроцедуры
 
#Область КомандыИзменения

&НаКлиенте
Процедура ПоказатьИзмененияВерсий(ИмяКоманды)

	СсылкаНаОбъект = ЭтаФорма.ДокументБУ; 
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Ссылка",СсылкаНаОбъект);
	СтруктураКоличествВерсий = сабОбщегоНазначенияБУХ.ПолучитьКоличествоВерсий(СсылкаНаОбъект);
	КолВерсий = СтруктураКоличествВерсий.КоличествоИзмененныхВерсий;
	СравниваемыеВерсии = Новый СписокЗначений;  
	Пока КолВерсий > 0 Цикл
		СравниваемыеВерсии.Добавить(СтруктураКоличествВерсий.КоличествоВерсий, СтруктураКоличествВерсий.КоличествоВерсий);
		СтруктураКоличествВерсий.КоличествоВерсий = СтруктураКоличествВерсий.КоличествоВерсий - 1;
		КолВерсий = КолВерсий - 1;
	КонецЦикла;
	ПараметрыОтчета.Вставить("СравниваемыеВерсии",СравниваемыеВерсии); 
	
	ОткрытьФорму("РегистрСведений.ВерсииОбъектов.Форма.ОтчетПоВерсиямОбъекта", ПараметрыОтчета);

КонецПроцедуры

&НаКлиенте
Процедура ПерезаполнитьПоДокументу(ИмяКоманды)

	ПерезаполнитьДокументНаОснованиинаСервере();

КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьДокументНаОснованиинаСервере()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ОбработкаЗаполненияСФормы(ЭтаФорма.ДокументБУ, Неопределено, Истина);
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
	//ОбновленнаяЗапись = РегистрыСведений.сабОбработкаДокументов.СоздатьМенеджерЗаписи();
	//ОбновленнаяЗапись.ДокументБУ = ЭтаФорма.ДокументБУ;
	//ОбновленнаяЗапись.ДокументУУ = Объект.Ссылка;
	//ОбновленнаяЗапись.ДатаОбработки = ТекущаяДата();
	//ОбновленнаяЗапись.Автор = ПараметрыСеанса.ТекущийПользователь;
	//ОбновленнаяЗапись.Модифицирован = Ложь;
	//ОбновленнаяЗапись.Записать();
	Элементы.ЭлементПерезаполнитьПоДокументу.Доступность = Ложь;
	
	ПриСозданииНаСервере(Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОповеститьРегистрОбработанных", Новый Структура("ДокументУУ, ДокументБУ", Объект.Ссылка, ?(БюджетныйНаКлиенте.ЕстьСвойствоОбъекта(ЭтаФорма, "ДокументБУ"), ЭтаФорма.ДокументБУ, Неопределено)));	
КонецПроцедуры


&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ЗаполнитьАртикул(); 
	
	//Синхронизация серий
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
		сабОперОбщегоНазначения.СинхронизацияСерийПослеЗаписиНаСервереФормы(Объект.Товары,Объект.СерииНоменклатуры);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьАртикул()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка,
	|	Номенклатура.Код КАК Код,
	|	Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка В(&СписокНоменклатур)";
	Запрос.УстановитьПараметр("СписокНоменклатур", Объект.Товары.Выгрузить().ВыгрузитьКолонку("Номенклатура"));
	
	ТаблицаАртикулов =  Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТЧ Из Объект.Товары Цикл
		НайденныеСтроки = ТаблицаАртикулов.НайтиСтроки(Новый Структура("Ссылка", СтрокаТЧ.Номенклатура));
		Для Каждого СтрокаСАртикулом Из НайденныеСтроки Цикл
			СтрокаТЧ.Артикул = СтрокаСАртикулом.Код;
			СтрокаТЧ.ЕдиницаИзмерения = СтрокаСАртикулом.ЕдиницаИзмерения;
		КонецЦикла;
		
		НайденныеСерии = Объект.СерииНоменклатуры.НайтиСтроки(Новый Структура("Номенклатура, НомерСтрокиРеализации", СтрокаТЧ.Номенклатура, СтрокаТЧ.НомерСтроки));
		Если НайденныеСерии.Количество() > 1 Тогда
			СтрокаТЧ.НесколькоСерий = Истина;
			СтрокаТЧ.СерияНоменклатуры = Неопределено;
		КонецЕсли;
		
	КонецЦикла;	
	
КонецПроцедуры	

&НаКлиенте
Процедура РеализацияСерияНоменклатурыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанные = Элементы.Реализация.ТекущиеДанные; 
	
	МассивПараметрыВыбора = Новый Массив;
	НовыйПараметрДата = Новый ПараметрВыбора("ДатаОтгрузки",Объект.Дата);
	НовыйПараметрСчет = Новый ПараметрВыбора("Счет",ТекДанные.Счет);  
	НовыйПараметрСклад = Новый ПараметрВыбора("Склад",?(ЗначениеЗаполнено(ТекДанные.Склад), ТекДанные.Склад, Объект.Склад));
	НовыйПараметрПредприятие = Новый ПараметрВыбора("Предприятие",Объект.Предприятие);
	МассивПараметрыВыбора.Добавить(НовыйПараметрДата);   
	МассивПараметрыВыбора.Добавить(НовыйПараметрСчет);
	МассивПараметрыВыбора.Добавить(НовыйПараметрСклад);
	МассивПараметрыВыбора.Добавить(НовыйПараметрПредприятие);
	НовыеПараметры = Новый ФиксированныйМассив(МассивПараметрыВыбора);
	
	Если ТекДанные.НесколькоСерий Тогда 
		
		СтандартнаяОбработка = Ложь;
		ТекФорма = ПолучитьФорму("Документ.УЧ_Реализация.Форма.ФормаПодбораСерий");  
		ТекФорма.Элементы.СерииНоменклатуры.ПодчиненныеЭлементы.СерииНоменклатурыСерияНоменклатуры.ПараметрыВыбора = НовыеПараметры;
		ТекФорма.Номенклатура = ТекДанные.Номенклатура;
		ТекФорма.Количество = ТекДанные.Количество;
		ТекФорма.НомерСтрокиРеализации = ТекДанные.НомерСтроки;
		Для каждого ТекСтрока Из Объект.СерииНоменклатуры Цикл
			Если ТекСтрока.Номенклатура = ТекДанные.Номенклатура И ТекСтрока.НомерСтрокиРеализации = ТекДанные.НомерСтроки Тогда
				НоваяСтрока = ТекФорма.СерииНоменклатуры.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			КонецЕсли;
		КонецЦикла;
		ТекФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Оп = Новый ОписаниеОповещения("ВыполнитьПослеОкончанияПодбора", ЭтотОбъект, Новый Структура);
		ТекФорма.ОписаниеОповещенияОЗакрытии = Оп;
		ТекФорма.Открыть(); 
	Иначе
		Элемент.ПараметрыВыбора = НовыеПараметры;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеОкончанияПодбора(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекДанные = Элементы.Реализация.ТекущиеДанные;
	МассивУдСерий = Новый Массив;
	Для каждого ТекСтрока Из Объект.СерииНоменклатуры Цикл
		Если ТекСтрока.Номенклатура = ТекДанные.Номенклатура И ТекСтрока.НомерСтрокиРеализации = ТекДанные.НомерСтроки Тогда
			МассивУдСерий.Добавить(ТекСтрока);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекУд Из МассивУдСерий Цикл
		Объект.СерииНоменклатуры.Удалить(ТекУд);
	КонецЦикла;
	
	НовоеКоличество = 0;
	Для каждого ТекСтрока Из Результат.СерииНоменклатуры Цикл
		НоваяСтрока = Объект.СерииНоменклатуры.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		НоваяСтрока.НомерСтрокиРеализации = ТекДанные.НомерСтроки;
		НовоеКоличество = НовоеКоличество + ТекСтрока.Количество; 
		НоваяСтрока.ДатаПроизводства = сабОбщегоНазначенияБУХ.ПолучитьДатуПроизводстваДляСерииНоменклатуры(ТекСтрока.СерияНоменклатуры);
	КонецЦикла;
	
	ТекДанные.Количество = НовоеКоличество;
	Объект.СерииНоменклатуры.Сортировать("НомерСтрокиРеализации");
	РеализацияКоличествоПриИзменении(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура РеализацияСерияНоменклатурыПриИзменении(Элемент)
	
	//Синхронизация серий
	ТекущиеДанные = Элементы.Реализация.ТекущиеДанные;
	сабОперОбщегоНазначенияНаКлиенте.ЗаполнитьТЧСерииПриИзмененииСерииВОсновнойТЧ(ТекущиеДанные,Объект.СерииНоменклатуры);
	//ТД = Элементы.Реализация.ТекущиеДанные; 
	//ПараметрыОтбораСерииНоменклатуры = Новый Структура("Номенклатура,НомерСтрокиРеализации",ТД.Номенклатура,ТД.НомерСтроки);
	//МассивНайденныеСтрокиСерииНоменклатуры = Объект.СерииНоменклатуры.НайтиСтроки(ПараметрыОтбораСерииНоменклатуры);
	//ИндексДляДобавления = Неопределено;
	//Для каждого НайденнаяСтрокаСерииНоменклатуры Из МассивНайденныеСтрокиСерииНоменклатуры Цикл
	//	Если ИндексДляДобавления = Неопределено Тогда
	//		ИндексДляДобавления = Объект.СерииНоменклатуры.Индекс(НайденнаяСтрокаСерииНоменклатуры);
	//	КонецЕсли;
	//	Объект.СерииНоменклатуры.Удалить(НайденнаяСтрокаСерииНоменклатуры);
	//КонецЦикла;
	//Если ИндексДляДобавления = Неопределено Тогда
	//	 ИндексДляДобавления = 0;
	//КонецЕсли;
	//НоваяСтрокаСерииНоменклатуры = Объект.СерииНоменклатуры.Вставить(ИндексДляДобавления);
	//НоваяСтрокаСерииНоменклатуры.Номенклатура = ТД.Номенклатура;
	//НоваяСтрокаСерииНоменклатуры.Количество = ТД.Количество;
	//НоваяСтрокаСерииНоменклатуры.НомерСтрокиРеализации = ТД.НомерСтроки;
	//НоваяСтрокаСерииНоменклатуры.СерияНоменклатуры = ТД.СерияНоменклатуры;
	//НоваяСтрокаСерииНоменклатуры.ДатаПроизводства = сабОбщегоНазначенияБУХ.ПолучитьДатуПроизводстваДляСерииНоменклатуры(ТД.СерияНоменклатуры);
	//Объект.СерииНоменклатуры.Сортировать("НомерСтрокиРеализации");

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//Синхронизация серий
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
		сабОперОбщегоНазначения.ПерезаполнитьТЧСерииНоменклатурыПередЗаписью(Объект.Товары,ТекущийОбъект.СерииНоменклатуры);
		Если Не Отказ И БюджетныйНаСервере.ЕстьСвойствоОбъекта(ЭтотОбъект, "ДокументБУ") И ЗначениеЗаполнено(ЭтотОбъект.ДокументБУ) И ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			ПараметрыЗаписи.Вставить("СинхронизироватьСерииНоменклатурыСДокументомБух",Истина); 
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеализацияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.Реализация.ТекущиеДанные.НесколькоСерий = Ложь;
	КонецЕсли; 
	//Синхронизация серий
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
		сабОперОбщегоНазначенияНаКлиенте.ЗаполнитьНомерИсходнойСтрокиДляСерии(Элемент.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РеализацияПриИзменении(Элемент)
	
	//Синхронизация серий
	Если сабОбщегоНазначенияПовтИсп.ПолучитьСерийныйУчет() Тогда
		сабОперОбщегоНазначенияНаКлиенте.СинхронизироватьНомерСтрокиРеализацииДляТЧСерии(Элемент.ТекущиеДанные,Объект.Товары,Объект.СерииНоменклатуры);
	КонецЕсли;
	
КонецПроцедуры


