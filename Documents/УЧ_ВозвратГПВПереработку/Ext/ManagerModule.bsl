﻿// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
		
	//Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
	//	
	//	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Накладная",
	//		НСтр("ru = 'Накладная'") + ?(ПараметрыПечати["ВыводитьЦены"], " " + НСтр("ru = '(с розничными ценами)'"), ""), 
	//		ПечатьНакладная(МассивОбъектов, ОбъектыПечати, ПараметрыПечати["ВыводитьЦены"]));
	//	
	//КонецЕсли;
	//
	//Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОписьНоменклатуры") Тогда

	//	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОписьНоменклатуры",
	//			ПараметрыПечати.Представление,
	//			ПечатьОписиНоменклатуры(МассивОбъектов, ОбъектыПечати));
	//
	//КонецЕсли;
			
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТОРГ12") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм,"ТОРГ12",
			НСтр("ru = 'ТОРГ-12 (Товарная накладная на возврат)'"), 
			ПечатьТОРГ12(МассивОбъектов));
		
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ТТН") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ТТН",
				ПараметрыПечати.Представление,
				ПечатьТТН(МассивОбъектов, ОбъектыПечати, ПараметрыПечати));
		
	КонецЕсли;
	
КонецПроцедуры

// Функция формирует печатную форму документа.
//
Функция ПечатьТОРГ12(МассивОбъектов) Экспорт
	
	КолонкаКодов = "Код";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДокументКПечати.Ссылка КАК Ссылка,
	|	ДокументКПечати.Номер КАК Номер,
	|	ДокументКПечати.Дата КАК Дата,
	|	ДокументКПечати.Контрагент КАК Контрагент,
	|	ДокументКПечати.Организация КАК Организация,
	|	ДокументКПечати.Организация КАК Руководители,
	|	ДокументКПечати.Организация.Код КАК Префикс,
	|	ДокументКПечати.Организация КАК Грузоотправитель,
	|	ДокументКПечати.Контрагент КАК Грузополучатель,
	|	ДокументКПечати.Организация КАК Поставщик,
	|	ДокументКПечати.Контрагент КАК Покупатель,
	|	ДокументКПечати.Контрагент КАК Плательщик,
	|	ДокументКПечати.Ответственный КАК ОтветственноеЛицо,
	|	ДокументКПечати.Контрагент.ОсновнойБанковскийСчет КАК БанковскийСчетКонтрагента,
	|	ДокументКПечати.Организация.ОсновнойБанковскийСчет КАК БанковскийСчетОрганизации,
	|	ДокументКПечати.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ДокументКПечати.УчитыватьНДС КАК УчитыватьНДС,
	|	ДокументКПечати.Подразделение,
	|	ВЫРАЗИТЬ(ДокументКПечати.Договор КАК Справочник.ДоговорыКонтрагентов).Наименование КАК Основание,
	|	ВЫРАЗИТЬ(ДокументКПечати.Договор КАК Справочник.ДоговорыКонтрагентов).Номер КАК НомерДоговора,
	|	ВЫРАЗИТЬ(ДокументКПечати.Договор КАК Справочник.ДоговорыКонтрагентов).ДатаДоговора КАК ДатаДоговора
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику КАК ДокументКПечати
	|ГДЕ
	|	ДокументКПечати.Ссылка В(&МассивДокументов)
	|	И ДокументКПечати.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Ссылка КАК Ссылка,
	|	ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	|	ВложенныйЗапрос.Номенклатура.НаименованиеПолное КАК ТоварНаименование,
	|	ВложенныйЗапрос.Номенклатура.Код КАК ТоварКод,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Представление КАК БазоваяЕдиницаНаименование,
	|	ВложенныйЗапрос.ЕдиницаИзмерения.Код КАК БазоваяЕдиницаКодПоОКЕИ,
	|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.ЕдиницаИзмеренияМест.Представление КАК ВидУпаковки,
	|	ВложенныйЗапрос.КоэффициентМест / ВложенныйЗапрос.Коэффициент КАК КоличествоВОдномМесте,
	|	ВложенныйЗапрос.СтавкаНДС КАК СтавкаНДС,
	|	ВложенныйЗапрос.Цена КАК Цена,
	|	ВложенныйЗапрос.Количество КАК Количество,
	|	ЕСТЬNULL(ВложенныйЗапрос.КоличествоМест, 0) КАК КоличествоМест,
	|	ВложенныйЗапрос.Сумма КАК Сумма,
	|	ВложенныйЗапрос.СуммаНДС КАК СуммаНДС,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	ВложенныйЗапрос.МассаБрутто КАК МассаБрутто,
	|	ЛОЖЬ КАК ЭтоВозвратнаяТара
	|ИЗ
	|	(ВЫБРАТЬ
	|		Товары.Ссылка КАК Ссылка,
	|		Товары.Номенклатура КАК Номенклатура,
	|		1 КАК Коэффициент,
	|		Товары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		1 КАК КоэффициентМест,
	|		Товары.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмеренияМест,
	|		Товары.Количество * Товары.Номенклатура.ВесБрутто КАК МассаБрутто,
	|		Товары.СтавкаНДС КАК СтавкаНДС,
	|		Товары.Цена КАК Цена,
	|		Товары.Количество КАК Количество,
	|		Товары.Количество КАК КоличествоМест,
	|		Товары.Сумма КАК Сумма,
	|		Товары.СуммаНДС КАК СуммаНДС,
	|		Товары.НомерСтроки КАК НомерСтроки
	|	ИЗ
	|		Документ.УЧ_ВозвратТоваровПоставщику.Товары КАК Товары
	|	ГДЕ
	|		Товары.Ссылка В(&МассивДокументов)
	|		И Товары.Ссылка.Проведен
	|		И Товары.Номенклатура.ТипНоменклатуры <> ЗНАЧЕНИЕ(Перечисление.сабТипыНоменклатуры.Услуга)) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка");
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВозвратТоваровПоставщику_ТОРГ12";
	
	ЕдиницаИзмеренияВеса           = Неопределено;
	
	ТабличныйДокумент.ПолеСлева = 5;
	ТабличныйДокумент.ПолеСправа = 5;
	ТабличныйДокумент.РазмерКолонтитулаСверху = 0;
	ТабличныйДокумент.РазмерКолонтитулаСнизу = 0;
	ТабличныйДокумент.АвтоМасштаб = Истина;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	ДанныеПечати = МассивРезультатов[0].Выбрать();
	ВыборкаПоДокументам = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ТОРГ12");
	
	ПервыйДокумент = Истина;
	Пока ДанныеПечати.Следующий() Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СведенияОПоставщике       = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Поставщик,        ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетОрганизации);
		СведенияОПокупателе       = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Покупатель,       ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетКонтрагента);
		СведенияОГрузополучателе  = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Грузополучатель,  ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетКонтрагента);
		СведенияОГрузоотправитель = ФормированиеПечатныхФормСервер.СведенияОЮрФизЛице(ДанныеПечати.Грузоотправитель, ДанныеПечати.Дата,, ДанныеПечати.БанковскийСчетОрганизации);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(ДанныеПечати);
		ОбластьМакета.Параметры.НомерДокумента = ДанныеПечати.Номер;
		ОбластьМакета.Параметры.ДатаДокумента  = ДанныеПечати.Дата;
		
		Если ДанныеПечати.Организация = ДанныеПечати.Грузоотправитель Тогда
			
			ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПоставщике, 
			"ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
			
		Иначе
			
			ОбластьМакета.Параметры.ПредставлениеОрганизации = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОГрузоотправитель, 
			"ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
			
		КонецЕсли;
		
		ОбластьМакета.Параметры.ПредставлениеГрузополучателя = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОГрузополучателе, 
		"ПолноеНаименование,ИНН,ФактическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
		
		ОбластьМакета.Параметры.ПредставлениеПоставщика  = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПоставщике, 
		"ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
		
		ОбластьМакета.Параметры.ПредставлениеПлательщика = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОПокупателе, 
		"ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет");
		
		ОбластьМакета.Параметры.ПредставлениеПодразделения = ДанныеПечати.Подразделение.Код + "; КПП: " + ДанныеПечати.Подразделение.КПП + "; Адрес: " + Справочники.СтруктураПредприятия.ПолучитьАдресИзКонтактнойИнформации(ДанныеПечати.Подразделение);
		ОбластьМакета.Параметры.АдресДоставки = ФормированиеПечатныхФормСервер.ОписаниеОрганизации(СведенияОГрузополучателе, "ФактическийАдрес");
		
		// Выводим коды
		ОбластьМакета.Параметры.ОрганизацияПоОКПО          = СведенияОПоставщике.КодПоОКПО;
		ОбластьМакета.Параметры.ВидДеятельностиПоОКДП      = "";
		ОбластьМакета.Параметры.ГрузополучательПоОКПО      = СведенияОПокупателе.КодПоОКПО;
		ОбластьМакета.Параметры.ПоставщикПоОКПО            = СведенияОПоставщике.КодПоОКПО;
		ОбластьМакета.Параметры.ПлательщикПоОКПО           = СведенияОПокупателе.КодПоОКПО;
		ОбластьМакета.Параметры.ОснованиеНомер             = ДанныеПечати.НомерДоговора;
		ОбластьМакета.Параметры.ОснованиеДата              = Формат(ДанныеПечати.ДатаДоговора, "ДФ=dd.MM.yyyy");
		ОбластьМакета.Параметры.ТранспортнаяНакладнаяНомер = "";
		ОбластьМакета.Параметры.ТранспортнаяНакладнаяДата  = "";
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		НомерСтраницы = 1;
		
		ИтоговыеСуммы = Новый Структура;
		
		// Инициализация итогов по странице.
		ИтоговыеСуммы.Вставить("ИтогоМассаБруттоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоМестНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоКоличествоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоСуммаНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоНДСНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоСуммаСНДСНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоМассаБруттоНаСтранице", 0);
		ИтоговыеСуммы.Вставить("ИтогоМассаНеттоНаСтранице", 0);
		
		// Инициализация итогов по документу.
		ИтоговыеСуммы.Вставить("ИтогоМассаБрутто", 0);
		ИтоговыеСуммы.Вставить("ИтогоМест", 0);
		ИтоговыеСуммы.Вставить("ИтогоКоличество", 0);
		ИтоговыеСуммы.Вставить("ИтогоСуммаСНДС", 0);
		ИтоговыеСуммы.Вставить("ИтогоСумма", 0);
		ИтоговыеСуммы.Вставить("ИтогоНДС", 0);
		ИтоговыеСуммы.Вставить("ИтогоМассаБрутто", 0);
		ИтоговыеСуммы.Вставить("ИтогоМассаНетто", 0);
		
		ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", 0);
		ИтоговыеСуммы.Вставить("СуммаПрописью", "");
		
		ДанныеСтроки = Новый Структура;
		ДанныеСтроки.Вставить("Номер", 0);
		ДанныеСтроки.Вставить("Мест", 0);
		ДанныеСтроки.Вставить("Количество", 0);
		ДанныеСтроки.Вставить("Цена", 0);
		ДанныеСтроки.Вставить("СуммаБезНДС", 0);
		ДанныеСтроки.Вставить("СуммаНДС", 0);
		ДанныеСтроки.Вставить("СуммаСНДС", 0);
		ДанныеСтроки.Вставить("МассаБрутто", 0);
		ДанныеСтроки.Вставить("МассаНетто", 0);
		
		
		// Создаем массив для проверки вывода.
		МассивВыводимыхОбластей = Новый Массив;
		
		// Выводим многострочную часть документа.
		ОбластьЗаголовокТаблицы = Макет.ПолучитьОбласть("ЗаголовокТаб");
		ОбластьМакета           = Макет.ПолучитьОбласть("Строка");
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьВсего            = Макет.ПолучитьОбласть("Всего");
		ОбластьПодвала          = Макет.ПолучитьОбласть("Подвал");
		
		СтруктураПоиска = Новый Структура("Ссылка", ДанныеПечати.Ссылка);
		ВыборкаПоДокументам.НайтиСледующий(СтруктураПоиска);
		
		КоличествоСтрок = ВыборкаПоДокументам.Количество();
		
		СтрокаТовары = ВыборкаПоДокументам.Выбрать();
		Пока СтрокаТовары.Следующий() Цикл
			
			ДанныеСтроки.Номер = ДанныеСтроки.Номер + 1;
			
			ОбластьМакета.Параметры.Заполнить(СтрокаТовары);
			ОбластьМакета.Параметры.ТоварНаименование = ФормированиеПечатныхФормСервер.ПолучитьПредставлениеНоменклатурыДляПечати(СтрокаТовары.ТоварНаименование);
			
			ДанныеСтроки.Мест = СтрокаТовары.КоличествоМест;
			ДанныеСтроки.Количество  = СтрокаТовары.Количество;
			
			Если ЕдиницаИзмеренияВеса <> Неопределено Тогда
				Если Не ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) Тогда
					ДанныеСтроки.МассаБрутто = 0;
				Иначе
					ДанныеСтроки.МассаБрутто = СтрокаТовары.МассаБрутто;
				КонецЕсли;
			КонецЕсли;
			
			ДанныеСтроки.СуммаСНДС   = Окр((СтрокаТовары.Сумма + ?(ДанныеПечати.ЦенаВключаетНДС, 0, СтрокаТовары.СуммаНДС)), 2);
			ДанныеСтроки.СуммаНДС    = СтрокаТовары.СуммаНДС;
			ДанныеСтроки.СуммаБезНДС = ДанныеСтроки.СуммаСНДС - ДанныеСтроки.СуммаНДС;
			
			Если ДанныеПечати.ЦенаВключаетНДС Тогда
				ДанныеСтроки.Цена = ?(ДанныеСтроки.Количество = 0, 0, ДанныеСтроки.СуммаБезНДС / ДанныеСтроки.Количество);
			Иначе
				ДанныеСтроки.Цена = СтрокаТовары.Цена;
			КонецЕсли;
			
			ОбластьМакета.Параметры.Заполнить(ДанныеСтроки);
			
			Если ДанныеСтроки.Номер = 1 Тогда // первая строка
				
				ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы; 
				ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
				
			Иначе
				
				МассивВыводимыхОбластей.Очистить();
				МассивВыводимыхОбластей.Добавить(ОбластьМакета);
				МассивВыводимыхОбластей.Добавить(ОбластьИтоговПоСтранице);
				
				Если ДанныеСтроки.Номер = КоличествоСтрок Тогда
					
					МассивВыводимыхОбластей.Добавить(ОбластьВсего);
					МассивВыводимыхОбластей.Добавить(ОбластьПодвала);
					
				КонецЕсли;
				
				Если ДанныеСтроки.Номер <> 1 И Не ТабличныйДокумент.ПроверитьВывод(МассивВыводимыхОбластей) Тогда
					
					ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
					ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
					
					ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице = 0;
					ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  = 0;
					ИтоговыеСуммы.ИтогоМестНаСтранице        = 0;
					ИтоговыеСуммы.ИтогоКоличествоНаСтранице  = 0;
					ИтоговыеСуммы.ИтогоСуммаНаСтранице       = 0;
					ИтоговыеСуммы.ИтогоНДСНаСтранице         = 0;
					ИтоговыеСуммы.ИтогоСуммаСНДСНаСтранице   = 0;
					
					НомерСтраницы = НомерСтраницы + 1;
					ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
					ОбластьЗаголовокТаблицы.Параметры.НомерСтраницы = "Страница " + НомерСтраницы;
					ТабличныйДокумент.Вывести(ОбластьЗаголовокТаблицы);
					
				КонецЕсли;
				
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Увеличим итоги по странице.
			ИтоговыеСуммы.ИтогоМестНаСтранице        = ИтоговыеСуммы.ИтогоМестНаСтранице        + ДанныеСтроки.Мест;
			ИтоговыеСуммы.ИтогоКоличествоНаСтранице  = ИтоговыеСуммы.ИтогоКоличествоНаСтранице  + ДанныеСтроки.Количество;
			ИтоговыеСуммы.ИтогоСуммаНаСтранице       = ИтоговыеСуммы.ИтогоСуммаНаСтранице       + ДанныеСтроки.СуммаБезНДС;
			ИтоговыеСуммы.ИтогоНДСНаСтранице         = ИтоговыеСуммы.ИтогоНДСНаСтранице         + ДанныеСтроки.СуммаНДС;
			ИтоговыеСуммы.ИтогоСуммаСНДСНаСтранице   = ИтоговыеСуммы.ИтогоСуммаСНДСНаСтранице   + ДанныеСтроки.СуммаСНДС;
			ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице = ИтоговыеСуммы.ИтогоМассаБруттоНаСтранице + ДанныеСтроки.МассаБрутто;
			ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  = ИтоговыеСуммы.ИтогоМассаНеттоНаСтранице  + ДанныеСтроки.МассаНетто;
			
			// Увеличим итоги по документу.
			ИтоговыеСуммы.ИтогоМест        = ИтоговыеСуммы.ИтогоМест        + ДанныеСтроки.Мест;
			ИтоговыеСуммы.ИтогоКоличество  = ИтоговыеСуммы.ИтогоКоличество  + ДанныеСтроки.Количество;
			ИтоговыеСуммы.ИтогоСумма       = ИтоговыеСуммы.ИтогоСумма       + ДанныеСтроки.СуммаБезНДС;
			ИтоговыеСуммы.ИтогоНДС         = ИтоговыеСуммы.ИтогоНДС         + ДанныеСтроки.СуммаНДС;
			ИтоговыеСуммы.ИтогоСуммаСНДС   = ИтоговыеСуммы.ИтогоСуммаСНДС   + ДанныеСтроки.СуммаСНДС;
			ИтоговыеСуммы.ИтогоМассаБрутто = ИтоговыеСуммы.ИтогоМассаБрутто + ДанныеСтроки.МассаБрутто;
			ИтоговыеСуммы.ИтогоМассаНетто  = ИтоговыеСуммы.ИтогоМассаНетто  + ДанныеСтроки.МассаНетто;
			
		КонецЦикла;
		
		// Выводим итоги по последней странице.
		ОбластьИтоговПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		ОбластьИтоговПоСтранице.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьИтоговПоСтранице);
		
		// Выводим итоги по документу в целом.
		ОбластьМакета = Макет.ПолучитьОбласть("Всего");
		ОбластьМакета.Параметры.Заполнить(ИтоговыеСуммы);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим подвал документа
		
		ИтоговыеСуммы.Вставить("КоличествоПорядковыхНомеровЗаписейПрописью", ЧислоПрописью(ДанныеСтроки.Номер, ,",,,,,,,,0"));
		ИтоговыеСуммы.Вставить("СуммаПрописью", ФормированиеПечатныхФормСервер.СформироватьСуммуПрописью(ИтоговыеСуммы.ИтогоСуммаСНДС));
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		
		ПолнаяДатаДокумента = Формат(ДанныеПечати.Дата, "ДЛФ=ДД");
		ДлинаСтроки = СтрДлина(ПолнаяДатаДокумента);
		ПервыйРазделитель = Найти(ПолнаяДатаДокумента, " ");
		ВторойРазделитель = Найти(Прав(ПолнаяДатаДокумента, ДлинаСтроки - ПервыйРазделитель), " ") + ПервыйРазделитель;
		ОбластьМакета.Параметры.ДатаДокументаДень = """" + Лев(ПолнаяДатаДокумента, ПервыйРазделитель -1 ) + """";
		ОбластьМакета.Параметры.ДатаДокументаМесяц = Сред(ПолнаяДатаДокумента, ПервыйРазделитель + 1, ВторойРазделитель - ПервыйРазделитель - 1);
		ОбластьМакета.Параметры.ДатаДокументаГод = Прав(ПолнаяДатаДокумента, ДлинаСтроки - ВторойРазделитель);
		
		Руководители = ФормированиеПечатныхФормСервер.ОтветственныеЛицаОрганизаций(ДанныеПечати.Руководители, ДанныеПечати.Дата);
		
		ОбластьМакета.Параметры.ФИОГлавБухгалтера     = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(Руководители.ГлавныйБухгалтер);
		ОбластьМакета.Параметры.ФИОРуководителя       = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(Руководители.Руководитель);
		ОбластьМакета.Параметры.ДолжностьРуководителя = Руководители.РуководительДолжность;
		СтруктураФИО = ФормированиеПечатныхФормСервер.ФамилияИмяОтчество(ДанныеПечати.ОтветственноеЛицо, ДанныеПечати.Дата);
		ОбластьМакета.Параметры.ФИОКладовщика         = ФормированиеПечатныхФормСервер.ФамилияИнициалыФизЛица(Неопределено,СтруктураФИО.Фамилия,СтруктураФИО.Имя,СтруктураФИО.Отчество);
		
		Если ИтоговыеСуммы.ИтогоМест > 0 Тогда
			
			ОбластьМакета.Параметры.ВсегоМестПрописью = ЧислоПрописью(ИтоговыеСуммы.ИтогоМест, ,",,,,,,,,0");
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ЕдиницаИзмеренияВеса) И ИтоговыеСуммы.ИтогоМассаБрутто > 0 Тогда
			
			ОбластьМакета.Параметры.МассаГрузаПрописью = ЧислоПрописью(ИтоговыеСуммы.ИтогоМассаБрутто, ,",,,,,,,,0")+ " " + СокрЛП(ЕдиницаИзмеренияВеса) + ".";
			
		КонецЕсли;
		
		ОбластьМакета.Параметры.КоличествоПорядковыхНомеровЗаписейПрописью = ИтоговыеСуммы.КоличествоПорядковыхНомеровЗаписейПрописью;
		ОбластьМакета.Параметры.СуммаПрописью = ИтоговыеСуммы.СуммаПрописью;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДанныеПечати.Ссылка);
		
	КонецЦикла;
	
	Возврат ТабличныйДокумент;
	
	
КонецФункции

Функция ПечатьТТН(МассивОбъектов, ОбъектыПечати, ПараметрыПечати) Экспорт
			
	КолонкаКодов = "Код";
	
	Запрос = Новый Запрос();
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Возврат.Ссылка КАК Ссылка,
	|	Возврат.Номер КАК Номер,
	|	Возврат.Дата КАК Дата,
	|	Возврат.Организация КАК Организация,
	|	Возврат.Организация КАК Руководители,
	|	Возврат.Контрагент КАК Грузополучатель,
	|	Возврат.Организация КАК Грузоотправитель,
	|	Возврат.Контрагент КАК Контрагент,
	|	Возврат.Организация.Код КАК Префикс,
	|	&СрокДоставки КАК СрокДоставки,
	|	&МаркаАвтомобиля КАК МаркаАвтомобиля,
	|	&МаркаПрицепа КАК МаркаПрицепа,
	|	&ГосНомерАвтомобиля КАК ГосНомерАвтомобиля,
	|	&ГосНомерПрицепа КАК ГосНомерПрицепа,
	|	&ПунктПогрузки КАК ПунктПогрузки,
	|	&ПунктРазгрузки КАК ПунктРазгрузки,
	|	&Водитель КАК Водитель,
	|	&Перевозчик КАК ПредставлениеПеревозчика,
	|	&Заказчик КАК ПредставлениеЗаказчика,
	|	&ВидПеревозки КАК ВидПеревозки,
	|	&ЛицензионнаяКарточка КАК ЛицензионнаяКарточка,
	|	&ВодительскоеУдостоверение КАК ВодительскоеУдостоверение,
	|	Возврат.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	Возврат.УчитыватьНДС КАК УчитыватьНДС,
	|	"""" КАК ДоверенностьНомер,
	|	"""" КАК ДоверенностьДата,
	|	"""" КАК ДоверенностьВыдана,
	|	"""" КАК ДоверенностьЛицо,
	|	НаименованияТоваров.Количество КАК КоличествоНаименований
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику КАК Возврат
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			СУММА(1) КАК Количество,
	|			СписокТоваров.Ссылка КАК Ссылка
	|		ИЗ
	|			(ВЫБРАТЬ
	|				Товары.Ссылка КАК Ссылка,
	|				Товары.Номенклатура КАК Номенклатура
	|			ИЗ
	|				Документ.УЧ_ВозвратТоваровПоставщику.Товары КАК Товары
	|			ГДЕ
	|				Товары.Ссылка В(&МассивДокументов)) КАК СписокТоваров
	|		
	|		СГРУППИРОВАТЬ ПО
	|			СписокТоваров.Ссылка) КАК НаименованияТоваров
	|		ПО Возврат.Ссылка = НаименованияТоваров.Ссылка
	|ГДЕ
	|	Возврат.Ссылка В(&МассивДокументов)
	|	И Возврат.Ссылка.Проведен
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Товары.Ссылка КАК Ссылка,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Номенклатура.Код КАК ТоварКод,
	|	Товары.Номенклатура.НаименованиеПолное КАК ТоварНаименование,
	|	Товары.Количество КАК Количество,
	|	Товары.Номенклатура.ЕдиницаИзмерения.Наименование КАК ВидУпаковки,
	|	Товары.Номенклатура.ЕдиницаИзмерения.Наименование КАК БазоваяЕдиницаНаименование,
	|	Товары.Цена КАК Цена,
	|	Товары.Количество * Товары.Номенклатура.ВесБрутто КАК МассаБрутто,
	|	Товары.Количество * Товары.Номенклатура.ВесНетто КАК МассаНетто,
	|	Товары.Количество КАК КоличествоМест,
	|	Товары.Сумма КАК Сумма,
	|	Товары.СуммаНДС КАК СуммаНДС,
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА Товары.Номенклатура.ВесНетто = 0
	|				И Товары.Номенклатура.ВесБрутто = 0
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Весовой
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В(&МассивДокументов)
	|	И Товары.Ссылка.Проведен
	|	И НЕ Товары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.сабТипыНоменклатуры.Услуга)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
		
	
	Запрос.УстановитьПараметр("МассивДокументов", МассивОбъектов);
	Запрос.УстановитьПараметр("СрокДоставки", ПараметрыПечати.СрокДоставки);
	Запрос.УстановитьПараметр("МаркаАвтомобиля", ПараметрыПечати.МаркаАвтомобиля);
	Запрос.УстановитьПараметр("МаркаПрицепа", ПараметрыПечати.МаркаПрицепа);
	Запрос.УстановитьПараметр("ГосНомерАвтомобиля", ПараметрыПечати.ГосНомерАвтомобиля);
	Запрос.УстановитьПараметр("ГосНомерПрицепа", ПараметрыПечати.ГосНомерПрицепа);
	Запрос.УстановитьПараметр("ПунктПогрузки", ПараметрыПечати.ПунктПогрузки);
	Запрос.УстановитьПараметр("ПунктРазгрузки", ПараметрыПечати.ПунктРазгрузки);
	Запрос.УстановитьПараметр("Водитель", ПараметрыПечати.Водитель);
	Запрос.УстановитьПараметр("Перевозчик", ПараметрыПечати.Перевозчик);
	Запрос.УстановитьПараметр("Заказчик", ПараметрыПечати.Заказчик);
	Запрос.УстановитьПараметр("ВидПеревозки", ПараметрыПечати.ВидПеревозки);
	Запрос.УстановитьПараметр("ЛицензионнаяКарточка", ПараметрыПечати.ЛицензионнаяКарточка);
	Запрос.УстановитьПараметр("ВодительскоеУдостоверение", ПараметрыПечати.ВодительскоеУдостоверение);
    	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВозвратТоваровПоставщику_ТТН";
	
	ФормированиеПечатныхФормСервер.ЗаполнитьТабличныйДокументТТН(ТабличныйДокумент, Запрос, ОбъектыПечати);
		
	Возврат ТабличныйДокумент;
    	
КонецФункции

// Функция получает данные для печатной формы Счета-фактуры.
//
Функция ПолучитьДанныеДляПечатнойФормыСчетФактура(ПараметрыПечати, МассивОбъектов) Экспорт
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокументов.Ссылка КАК Ссылка,
	|	ДанныеДокументов.Организация КАК Организация,
	|	ДанныеДокументов.ЦенаВключаетНДС КАК ЦенаВключаетНДС,
	|	ДанныеДокументов.Подразделение
	|ПОМЕСТИТЬ ТаблицаДанныхДокументов
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику КАК ДанныеДокументов
	|ГДЕ
	|	ДанныеДокументов.Ссылка В(&МассивОбъектов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Ссылка";
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Запрос.Выполнить();
	
	ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц);
	ПоместитьВременнуюТаблицуСчетовФактур(МенеджерВременныхТаблиц);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	&ПредставлениеСчетФактура КАК ПредставлениеДокумента,
	|	ЕСТЬNULL(СчетаФактуры.Номер, НЕОПРЕДЕЛЕНО) КАК Номер,
	|	ЕСТЬNULL(СчетаФактуры.Дата, НЕОПРЕДЕЛЕНО) КАК Дата,
	|	ЕСТЬNULL(СчетаФактуры.НомерИсправления, НЕОПРЕДЕЛЕНО) КАК НомерИсправления,
	|	ЕСТЬNULL(СчетаФактуры.ДатаИсправления, НЕОПРЕДЕЛЕНО) КАК ДатаИсправления,
	|	ЕСТЬNULL(СчетаФактуры.Исправление, ЛОЖЬ) КАК Исправление,
	|	НЕОПРЕДЕЛЕНО КАК НомерСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК НомерИсправленияСчетаФактуры,
	|	НЕОПРЕДЕЛЕНО КАК ДатаИсправленияСчетаФактуры,
	|	ЕСТЬNULL(СчетаФактуры.СтрокаПлатежноРасчетныеДокументы, """") КАК СтрокаПоДокументу,
	|	ЕСТЬNULL(СчетаФактуры.Валюта, НЕОПРЕДЕЛЕНО) КАК ВалютаСчетаФактуры,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Организация.Код КАК Префикс,
	|	ДанныеДокумента.Контрагент КАК Грузополучатель,
	|	ДанныеДокумента.Организация КАК Грузоотправитель,
	|	"""" КАК АдресДоставки,
	|	ЛОЖЬ КАК ТолькоУслуги,
	|	ДанныеДокумента.Подразделение
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику КАК ДанныеДокумента
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ФильтрПоДокументу
	|		ПО ДанныеДокумента.Ссылка = ФильтрПоДокументу.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСчетовФактур КАК СчетаФактуры
	|		ПО ДанныеДокумента.Ссылка = СчетаФактуры.ДокументОснование
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Ссылка КАК Ссылка,
	|	ТаблицаДокумента.Номенклатура КАК Номенклатура,
	|	ТаблицаДокумента.Номенклатура.НаименованиеПолное КАК НоменклатураНаименование,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Представление КАК ЕдиницаИзмеренияНаименование,
	|	ТаблицаДокумента.Номенклатура.ЕдиницаИзмерения.Код КАК ЕдиницаИзмеренияКод,
	|	ТаблицаДокумента.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаДокумента.Количество КАК Количество,
	|	ТаблицаДокумента.СуммаНДС КАК СуммаНДС,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ЦенаВключаетНДС
	|			ТОГДА ТаблицаДокумента.Сумма
	|		ИНАЧЕ ТаблицаДокумента.Сумма + ТаблицаДокумента.СуммаНДС
	|	КОНЕЦ КАК СуммаСНДС,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ЦенаВключаетНДС
	|			ТОГДА ТаблицаДокумента.Сумма - ТаблицаДокумента.СуммаНДС
	|		ИНАЧЕ ТаблицаДокумента.Сумма + ТаблицаДокумента.СуммаНДС - ТаблицаДокумента.СуммаНДС
	|	КОНЕЦ КАК СуммаБезНДС,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ЦенаВключаетНДС
	|			ТОГДА (ТаблицаДокумента.Сумма - ТаблицаДокумента.СуммаНДС) / ТаблицаДокумента.Количество
	|		ИНАЧЕ ТаблицаДокумента.Цена
	|	КОНЕЦ КАК Цена,
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.СтранаПроисхождения,
	|	ТаблицаДокумента.НомерГТД
	|ИЗ
	|	ТаблицаТоваров КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("ПредставлениеСчетФактура", НСтр("ru='счет-фактура'"));
	
	МассивРезультатов         = Запрос.ВыполнитьПакет();
	РезультатПоШапке          = МассивРезультатов[0];
	РезультатПоТабличнойЧасти = МассивРезультатов[1];
	
	СтруктураДанныхДляПечати 	= Новый Структура("РезультатПоШапке, РезультатПоТабличнойЧасти",
	                                               РезультатПоШапке, РезультатПоТабличнойЧасти);
	
	Возврат СтруктураДанныхДляПечати;
	
КонецФункции

// Формирует временную таблицу, содержащую табличную часть по таблице данных документов.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу
//	                                                    ТаблицаДанныхДокументов с полями: Ссылка.
//
Процедура ПоместитьВременнуюТаблицуТоваров(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаТоваров.Ссылка,
	|	ТаблицаТоваров.НомерСтроки,
	|	ТаблицаТоваров.Номенклатура,
	|	ТаблицаТоваров.Количество,
	|	ТаблицаТоваров.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
	|	ТаблицаТоваров.Количество КАК Количество1,
	|	ТаблицаТоваров.Цена,
	|	ТаблицаТоваров.Сумма,
	|	ТаблицаТоваров.СтавкаНДС,
	|	ТаблицаТоваров.СуммаНДС,
	|	ДанныеДокументов.ЦенаВключаетНДС,
	|	ВЫБОР
	|		КОГДА ТаблицаТоваров.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.сабТипыНоменклатуры.Товар)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоТовар,
	|	ТаблицаТоваров.Номенклатура.НомерГТД КАК НомерГТД,
	|	ТаблицаТоваров.Номенклатура.Страна КАК СтранаПроисхождения
	|ПОМЕСТИТЬ ТаблицаТоваров
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику.Товары КАК ТаблицаТоваров
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	|		ПО ТаблицаТоваров.Ссылка = ДанныеДокументов.Ссылка";

	
	Запрос.Выполнить();
	
КонецПроцедуры

// Формирует временную таблицу, содержащую данные счетов-фактур по таблице данных документов-оснований.
//
// Параметры:
//	МенеджерВременныхТаблиц - МенеджерВременныхТаблиц - Менеджер временных таблиц, содержащий таблицу
//	                                                    ТаблицаДанныхДокументов с полями:
//		Ссылка,
//		Организация,
//		Подразделение,
//		Склад.
//
Процедура ПоместитьВременнуюТаблицуСчетовФактур(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
	//"ВЫБРАТЬ
	//|	СчетаФактуры.ДокументОснование КАК ДокументОснование,
	//|	ВЫБОР
	//|		КОГДА СчетаФактуры.Исправление
	//|			ТОГДА ЕСТЬNULL(СчетаФактуры.СчетФактураОснование.Дата, НЕОПРЕДЕЛЕНО)
	//|		ИНАЧЕ СчетаФактуры.Дата
	//|	КОНЕЦ КАК Дата,
	//|	МАКСИМУМ(СчетаФактуры.НомерИсправления) КАК НомерИсправления
	//|ПОМЕСТИТЬ НомераИсправлений
	//|ИЗ
	//|	Документ.СчетФактураВыданный КАК СчетаФактуры
	//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДанныхДокументов КАК ДанныеДокументов
	//|		ПО СчетаФактуры.ДокументОснование = ДанныеДокументов.Ссылка
	//|ГДЕ
	//|	НЕ СчетаФактуры.ПометкаУдаления
	//|
	//|СГРУППИРОВАТЬ ПО
	//|	СчетаФактуры.ДокументОснование,
	//|	ВЫБОР
	//|		КОГДА СчетаФактуры.Исправление
	//|			ТОГДА ЕСТЬNULL(СчетаФактуры.СчетФактураОснование.Дата, НЕОПРЕДЕЛЕНО)
	//|		ИНАЧЕ СчетаФактуры.Дата
	//|	КОНЕЦ
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	СчетаФактуры.ДокументОснование КАК ДокументОснование,
	//|	СчетаФактуры.Исправление КАК Исправление,
	//|	СчетаФактуры.Номер КАК Номер,
	//|	ВЫБОР
	//|		КОГДА СчетаФактуры.Исправление
	//|			ТОГДА ЕСТЬNULL(СчетаФактуры.СчетФактураОснование.Дата, ДАТАВРЕМЯ(1, 1, 1))
	//|		ИНАЧЕ СчетаФактуры.Дата
	//|	КОНЕЦ КАК Дата,
	//|	ВЫБОР
	//|		КОГДА СчетаФактуры.Исправление
	//|			ТОГДА СчетаФактуры.НомерИсправления
	//|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	//|	КОНЕЦ КАК НомерИсправления,
	//|	ВЫБОР
	//|		КОГДА СчетаФактуры.Исправление
	//|			ТОГДА СчетаФактуры.Дата
	//|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	//|	КОНЕЦ КАК ДатаИсправления,
	//|	СчетаФактуры.Организация КАК Организация,
	//|	СчетаФактуры.Валюта КАК Валюта,
	//|	СчетаФактуры.СтрокаПлатежноРасчетныеДокументы КАК СтрокаПлатежноРасчетныеДокументы,
	//|	СчетаФактуры.Организация КАК Грузоотправитель
	//|ПОМЕСТИТЬ ТаблицаСчетовФактур
	//|ИЗ
	//|	НомераИсправлений КАК НомераИсправлений
	//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК СчетаФактуры
	//|		ПО НомераИсправлений.ДокументОснование = СчетаФактуры.ДокументОснование
	//|			И (НомераИсправлений.Дата = ВЫБОР
	//|				КОГДА СчетаФактуры.Исправление
	//|					ТОГДА ЕСТЬNULL(СчетаФактуры.СчетФактураОснование.Дата, НЕОПРЕДЕЛЕНО)
	//|				ИНАЧЕ СчетаФактуры.Дата
	//|			КОНЕЦ)
	//|			И НомераИсправлений.НомерИсправления = СчетаФактуры.НомерИсправления
	//|			И (НЕ СчетаФактуры.ПометкаУдаления)
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|УНИЧТОЖИТЬ НомераИсправлений";
	
	"ВЫБРАТЬ
	|	УЧ_ВозвратТоваровПоставщику.Ссылка КАК ДокументОснование,
	|	ВЫБОР
	|		КОГДА УЧ_ВозвратТоваровПоставщику.ИсправлениеСФ
	|			ТОГДА УЧ_ВозвратТоваровПоставщикуИсправленныеСФ.ДатаИсправления
	|		ИНАЧЕ УЧ_ВозвратТоваровПоставщику.ДатаСчетФактуры
	|	КОНЕЦ КАК Дата,
	|	МАКСИМУМ(УЧ_ВозвратТоваровПоставщикуИсправленныеСФ.НомерИсправления) КАК НомерИсправления
	|ПОМЕСТИТЬ НомераИсправлений
	|ИЗ
	|	ТаблицаДанныхДокументов КАК ТаблицаДанныхДокументов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.УЧ_ВозвратТоваровПоставщику КАК УЧ_ВозвратТоваровПоставщику
	|			ЛЕВОЕ СОЕДИНЕНИЕ Документ.УЧ_ВозвратТоваровПоставщику.ИсправленныеСФ КАК УЧ_ВозвратТоваровПоставщикуИсправленныеСФ
	|			ПО УЧ_ВозвратТоваровПоставщику.Ссылка = УЧ_ВозвратТоваровПоставщикуИсправленныеСФ.Ссылка
	|		ПО ТаблицаДанныхДокументов.Ссылка = УЧ_ВозвратТоваровПоставщику.Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	УЧ_ВозвратТоваровПоставщику.Ссылка,
	|	ВЫБОР
	|		КОГДА УЧ_ВозвратТоваровПоставщику.ИсправлениеСФ
	|			ТОГДА УЧ_ВозвратТоваровПоставщикуИсправленныеСФ.ДатаИсправления
	|		ИНАЧЕ УЧ_ВозвратТоваровПоставщику.ДатаСчетФактуры
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	УЧ_ВозвратТоваровПоставщику.Ссылка КАК ДокументОснование,
	|	УЧ_ВозвратТоваровПоставщику.ИсправлениеСФ КАК Исправление,
	|	УЧ_ВозвратТоваровПоставщику.НомерСчетФактуры КАК Номер,
	|	УЧ_ВозвратТоваровПоставщику.Организация,
	|	УЧ_ВозвратТоваровПоставщику.Организация КАК Грузоотправитель,
	|	УЧ_ВозвратТоваровПоставщику.Валюта,
	|	УЧ_ВозвратТоваровПоставщику.СтрокаПлатежноРасчетныеДокументы,
	|	ВЫБОР
	|		КОГДА УЧ_ВозвратТоваровПоставщику.ИсправлениеСФ
	|			ТОГДА ЕСТЬNULL(УЧ_ВозвратТоваровПоставщику.ДатаСчетФактуры, ДАТАВРЕМЯ(1, 1, 1))
	|		ИНАЧЕ НомераИсправлений.Дата
	|	КОНЕЦ КАК Дата,
	|	ВЫБОР
	|		КОГДА УЧ_ВозвратТоваровПоставщику.ИсправлениеСФ
	|			ТОГДА НомераИсправлений.НомерИсправления
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК НомерИсправления,
	|	ВЫБОР
	|		КОГДА УЧ_ВозвратТоваровПоставщику.ИсправлениеСФ
	|			ТОГДА НомераИсправлений.Дата
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК ДатаИсправления
	|ПОМЕСТИТЬ ТаблицаСчетовФактур
	|ИЗ
	|	Документ.УЧ_ВозвратТоваровПоставщику КАК УЧ_ВозвратТоваровПоставщику
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ НомераИсправлений КАК НомераИсправлений
	|		ПО УЧ_ВозвратТоваровПоставщику.Ссылка = НомераИсправлений.ДокументОснование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|УНИЧТОЖИТЬ НомераИсправлений";
	
	
	Запрос.Выполнить();
	
КонецПроцедуры
