﻿// Функция формирует табличный документ с печатной формой.
//
// Возвращаемое значение:
//  ТабличныйДокумент - печатная форма.
//
Функция ПечатьНакладная(МассивОбъектов, ОбъектыПечати = Неопределено, ПечатьКомплекта = Ложь) Экспорт

	КолонкаКодов       = "Код";
	ВыводитьКоды       = Истина;
	ТабличныйДокумент  = Новый ТабличныйДокумент;
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	СинонимДокумента   = НСтр("ru='Возврат товаров'");
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Документ.Ссылка КАК Ссылка,
	|	Документ.Номер КАК Номер,
	|	Документ.Дата КАК Дата,
	|	ВЫБОР
	|		КОГДА Документ.Организация.ЮридическоеФизическоеЛицо = ЗНАЧЕНИЕ(Перечисление.ЮридическоеФизическоеЛицо.ЮридическоеЛицо)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ОрганизацияЮридическоеЛицо,
	|	Документ.Организация КАК Поставщик,
	|	Документ.СуммаДокумента КАК СуммаДокумента,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Организация) КАК ПредставлениеПоставщика,
	|	Документ.Автор КАК Ответственный,
	|	Документ.Контрагент КАК Получатель,
	|	ПРЕДСТАВЛЕНИЕ(Документ.Контрагент) КАК ПредставлениеПолучателя,
	|	Документ.УчитыватьНДС КАК УчитыватьНДС,
	|	Документ.СуммаВключаетНДС КАК ЦенаВключаетНДС,
	|	Документ.Предприятие.НаименованиеОрганизацииДляПечати КАК НаименованиеОрганизацииДляПечати
	|ИЗ
	|	Документ.УЧ_Возврат КАК Документ
	|ГДЕ
	|	Документ.Ссылка В(&МассивОбъектов)
	|	И Документ.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Номенклатура.Код КАК КолонкаКодов,
	|	ТаблицаТовары.Номенклатура.Представление КАК Товар,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Номенклатура.НаименованиеПолное = """"
	|			ТОГДА ТаблицаТовары.Номенклатура.Наименование
	|		ИНАЧЕ ТаблицаТовары.Номенклатура.НаименованиеПолное
	|	КОНЕЦ КАК НоменклатураПредставление,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
	|	ПРЕДСТАВЛЕНИЕ(ТаблицаТовары.Номенклатура.ЕдиницаИзмерения) КАК ЕдиницаИзмерения,
	|	ТаблицаТовары.Количество КАК Количество,
	|	ТаблицаТовары.Количество КАК КоличествоУпаковок,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Количество = 0
	|			ТОГДА ТаблицаТовары.Количество
	|		ИНАЧЕ ТаблицаТовары.Сумма / ТаблицаТовары.Количество
	|	КОНЕЦ КАК Цена,
	|	ТаблицаТовары.Сумма КАК Сумма,
	|	ТаблицаТовары.Ссылка КАК Ссылка,
	|	ТаблицаТовары.Сумма КАК СуммаБезСкидки,
	|	0 КАК Скидка,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС
	|ИЗ
	|	Документ.УЧ_Возврат.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка В(&МассивОбъектов)
	|	И ТаблицаТовары.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка");
	
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	Запрос.УстановитьПараметр("Счет7902", ПланыСчетов.Учетный.Счет7902());
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.УЧ_Реализация.ПФ_MXL_Накладная");
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	
	ОбластьШапкаНомера         = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
	ОбластьШапкаКодов          = Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
	ОбластьШапкаДанных         = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
	ОбластьШапкаСкидок         = Макет.ПолучитьОбласть("ШапкаТаблицы|Скидка");
	ОбластьШапкаСуммы          = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");
	
	ОбластьКолонкаТовар = Макет.Область("Товар");
	Если Не ВыводитьКоды Тогда
		ОбластьКолонкаТовар.ШиринаКолонки = ОбластьКолонкаТовар.ШиринаКолонки
		                                  + Макет.Область("КолонкаКодов").ШиринаКолонки;
	КонецЕсли;
	ОбластьСтрокаНомера         = Макет.ПолучитьОбласть("Строка|НомерСтроки");
	ОбластьСтрокаКодов          = Макет.ПолучитьОбласть("Строка|КолонкаКодов");
	ОбластьСтрокаДанных         = Макет.ПолучитьОбласть("Строка|Данные");
	ОбластьСтрокаСкидок         = Макет.ПолучитьОбласть("Строка|Скидка");
	ОбластьСтрокаСуммы          = Макет.ПолучитьОбласть("Строка|Сумма");
	
	ОбластьИтогоНДСНомера = Макет.ПолучитьОбласть("ИтогоНДС|НомерСтроки");
	ОбластьИтогоНДСКодов  = Макет.ПолучитьОбласть("ИтогоНДС|КолонкаКодов");
	ОбластьИтогоНДСДанных = Макет.ПолучитьОбласть("ИтогоНДС|Данные");
	ОбластьИтогоНДССкидок = Макет.ПолучитьОбласть("ИтогоНДС|Скидка");
	ОбластьИтогоНДССуммы  = Макет.ПолучитьОбласть("ИтогоНДС|Сумма");
	
	// Вывести Итого.
	ОбластьИтогоНомера         = Макет.ПолучитьОбласть("Итого|НомерСтроки");
	ОбластьИтогоКодов          = Макет.ПолучитьОбласть("Итого|КолонкаКодов");
	ОбластьИтогоДанных         = Макет.ПолучитьОбласть("Итого|Данные");
	ОбластьИтогоСкидок         = Макет.ПолучитьОбласть("Итого|Скидка");
	ОбластьИтогоСуммы          = Макет.ПолучитьОбласть("Итого|Сумма");
	
	ОбластьСуммаПрописью = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьПодписей      = Макет.ПолучитьОбласть("Подписи");
	
	
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента, ВыборкаПоДокументам);
		ОбластьЗаголовок.Параметры.Заполнить(ВыборкаПоДокументам);
		
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = ФормированиеПечатныхФормСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента);					
		Если ВыборкаПоДокументам.НаименованиеОрганизацииДляПечати = "" Тогда
			ПредставлениеПоставщика = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ВыборкаПоДокументам.Поставщик, ВыборкаПоДокументам.Дата), "ПолноеНаименование,");	
		Иначе
			ПредставлениеПоставщика = ВыборкаПоДокументам.НаименованиеОрганизацииДляПечати;	
		КонецЕсли;
		ОбластьЗаголовок.Параметры.ПредставлениеПоставщика = ПредставлениеПоставщика;		
		ПредставлениеПолучателя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ВыборкаПоДокументам.Получатель, ВыборкаПоДокументам.Дата), "ПолноеНаименование,");
		//Если ЗначениеЗаполнено(МассивОбъектов.АдресДоставки) Тогда
		//	АдресДоставки = МассивОбъектов.АдресДоставки; 
		//Иначе
		//	АдресДоставки = Справочники.СтруктураПредприятия.ПолучитьАдресИзКонтактнойИнформации(МассивОбъектов.ПодразделениеВн);
		//КонецЕсли;
		//ОбластьЗаголовок.Параметры.ПредставлениеПолучателя = ПредставлениеПолучателя + ", " + АдресДоставки;//Сож+ адрес доставки
		
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// Шапка
		
		ЕстьСкидка 		  = Ложь;
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			Если ВыборкаПоСтрокамТЧ.Скидка Тогда
				ЕстьСкидка = Истина;			
			КонецЕсли;	
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьШапкаНомера);
		Если ВыводитьКоды Тогда
			ОбластьШапкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов;
			ТабличныйДокумент.Присоединить(ОбластьШапкаКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьШапкаДанных);
		Если ЕстьСкидка Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкаСкидок);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьШапкаСуммы);
		
		
		ВсегоНаименований = 0;
		Сумма             = 0;
		ВсегоСкидок       = 0;
		ВсегоБезСкидок    = 0;
		СуммаНДС          = 0;
		
		
		// СТРОКИ ТЧ
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			Если НЕ ЗначениеЗаполнено(ВыборкаПоСтрокамТЧ.Номенклатура) Тогда
				Продолжить;
			КонецЕсли;

			ОбластьСтрокаНомера.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Вывести(ОбластьСтрокаНомера);

			Если ВыводитьКоды Тогда
				
				ОбластьСтрокаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ["КолонкаКодов"];
				ТабличныйДокумент.Присоединить(ОбластьСтрокаКодов);
				
			КонецЕсли;

			ОбластьСтрокаДанных.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ОбластьСтрокаДанных.Параметры.Товар = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаПоСтрокамТЧ.НоменклатураПредставление);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаДанных);
			
			Если ЕстьСкидка Тогда
				ОбластьСтрокаСкидок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
				ТабличныйДокумент.Присоединить(ОбластьСтрокаСкидок);
			КонецЕсли;
			
			ОбластьСтрокаСуммы.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаСуммы);
			
			ВсегоНаименований = ВсегоНаименований + 1;
			
			Сумма          = Сумма       + ВыборкаПоСтрокамТЧ.Сумма;
			ВсегоСкидок    = ВсегоСкидок + ВыборкаПоСтрокамТЧ.Скидка;
			ВсегоБезСкидок = Сумма       + ВсегоСкидок;
			СуммаНДС       = СуммаНДС    + Окр(ВыборкаПоСтрокамТЧ.СуммаНДС, 2, 1);
			
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьИтогоНомера);
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьИтогоКодов);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьИтогоДанных);
		Если ЕстьСкидка Тогда
			ОбластьИтогоСкидок.Параметры.ВсегоСкидок    = ВсегоСкидок;
			ОбластьИтогоСкидок.Параметры.ВсегоБезСкидок = ВсегоБезСкидок;
			ТабличныйДокумент.Присоединить(ОбластьИтогоСкидок);
		КонецЕсли;
		ОбластьИтогоСуммы.Параметры.Всего = Сумма;
		ТабличныйДокумент.Присоединить(ОбластьИтогоСуммы);
		
		
		// Вывести ИтогоНДС
		ТабличныйДокумент.Вывести(ОбластьИтогоНДСНомера);
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьИтогоНДСКодов);
		КонецЕсли;
		
		ОбластьИтогоНДСДанных.Параметры.НДС = ?(ВыборкаПоДокументам.ЦенаВключаетНДС, НСтр("ru = 'В том числе НДС:'"), НСтр("ru = 'Сумма НДС:'"));
		ТабличныйДокумент.Присоединить(ОбластьИтогоНДСДанных);
		
		Если ЕстьСкидка Тогда
			ТабличныйДокумент.Присоединить(ОбластьИтогоНДССкидок);
		КонецЕсли;
		
		Если НЕ ВыборкаПоДокументам.УчитыватьНДС Тогда
			СуммаНДССтрока = НСтр("ru = 'Без НДС'");
		Иначе
			СуммаНДССтрока = Строка(СуммаНДС);
		КонецЕсли;
		
		ОбластьИтогоНДССуммы.Параметры.ВсегоНДС = СуммаНДССтрока;
		ТабличныйДокумент.Присоединить(ОбластьИтогоНДССуммы);
		
		
		// Вывести Сумму прописью.
		
		ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%, на сумму %Итого%'");
		
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", ВсегоНаименований);
		ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%Итого%", ФормированиеПечатныхФормСервер.ФорматСумм(Сумма));
		
		ОбластьСуммаПрописью.Параметры.ИтоговаяСтрока = ТекстИтоговойСтроки;
		ОбластьСуммаПрописью.Параметры.СуммаПрописью  = ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(Сумма);
		
		ТабличныйДокумент.Вывести(ОбластьСуммаПрописью);
		
		// ПОДПИСИ
		ОбластьПодписей.Параметры.Заполнить(ВыборкаПоДокументам);
		ОбластьПодписей.Параметры.ОтветственныйПредставление = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Ответственный);
		ТабличныйДокумент.Вывести(ОбластьПодписей);
		
		//УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
		Если ПечатьКомплекта И Не ОбъектыПечати = Неопределено Тогда 
			ФормированиеПечатныхФормСервер.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		КонецЕсли;
			
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

