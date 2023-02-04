﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
		
	ДокументРезультат.Очистить();
	
	ПоДвумСценариям = Ложь;
	ПоПодразделениям = Ложь;
	Представление = "Предприятие";
	
	Для Каждого ЭлементНастройки из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы цикл
		
		Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") тогда
			
			если Строка(ЭлементНастройки.Параметр) = "ВыбПериод" тогда
				ТекПериод = ЭлементНастройки.Значение;
			
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сценарий1" тогда
				Сценарий1 = ЭлементНастройки.Значение;
				СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ДатаКурсаБюджСц1", Сценарий1.АктуальнаяДата, Истина);				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сценарий1Вариант" тогда
				ВариантСценария1 = ЭлементНастройки.Значение;
			
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сценарий2" тогда
				Сценарий2 = ?(ЭлементНастройки.Использование, ЭлементНастройки.Значение, ПараметрыСеанса.ДоступныеПредприятия);
				ПоДвумСценариям = ЭлементНастройки.Использование;
				СтандартныеОтчетыКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "ДатаКурсаБюджСц2", Сценарий2.АктуальнаяДата, Истина);				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Предприятия" тогда
				Предприятия = ?(ЭлементНастройки.Использование, ЭлементНастройки.Значение, ПараметрыСеанса.ДоступныеПредприятия);
			
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Интервал" тогда
				Интервал = ?(ЭлементНастройки.Использование, ЭлементНастройки.Значение, "Месяц");
			
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сводный" тогда
				Сводный = ЭлементНастройки.Использование и ЭлементНастройки.Значение;
			
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Подразделения" тогда
				ПоПодразделениям = ЭлементНастройки.Использование и ЭлементНастройки.Значение;
				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "ИсключитьКазну" тогда
				ИсключитьКазну = ЭлементНастройки.Использование и ЭлементНастройки.Значение;
				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Представление" тогда
				Представление = ЭлементНастройки.Значение;
				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "ПоПодразделениям" тогда
				ПоПодразделениям = ЭлементНастройки.Значение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
		
	
	Расшифровка = Ложь;
	ПараметрКоманды = Новый 
	Структура("Период, Сценарий1, ВариантСценария1, Сценарий2, Предприятия, Интервал, Сводный, ИспользованиеПредприятия,ИсключитьКазну", ТекПериод,
	Сценарий1, ВариантСценария1, Сценарий2, Предприятия, Интервал, Сводный, КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[4].Использование,ИсключитьКазну);
		
	Попытка
		ЭтотОбъект2 = ВнешниеОтчеты.Создать("Д_ОтчетОДДС1");	
	Исключение
		ЭтотОбъект2 = Отчеты.Д_ОтчетОДДС1;
	КонецПопытки;
	
	// квартал помесячно год поквартально
	ИнтервалМеньше = БюджетныйНаСервере.ИнтервалМеньшеПериода(ТекПериод, Интервал);
		
	СКД = ЭтотОбъект2.ПолучитьМакет("СКД_По1Сценарию");
		
	СформироватьТекстЗапросаОстатков(ПараметрКоманды, СКД);
	
	Источник = новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД);
	КомпоновщикНастроек2 = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек2.Инициализировать(Источник);
	КомпоновщикНастроек2.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
	КомпоновщикНастроек2.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроек.ПользовательскиеНастройки);
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек2.ПолучитьНастройки();
	
	Для Каждого ТекЭлемент Из НастройкиДляКомпоновкиМакета.ПараметрыДанных.Элементы Цикл
		
		Если Строка(ТекЭлемент.Параметр) = "Сценарий2" тогда
			
			Если ЗначениеЗаполнено(ТекЭлемент.Значение) И ТекЭлемент.Использование Тогда
					
				//для вертикального вида
				ПроверкаИмя = НастройкиДляКомпоновкиМакета.Структура[1].Строки[0];
				ПроверкаКолич = НастройкиДляКомпоновкиМакета.Структура[1].Строки;
				
				Пока НЕ ПроверкаИмя.Имя = "ПредприятиеП" ИЛИ НЕ ПроверкаКолич.Количество() Цикл
					
					Попытка
						ПроверкаИмя = ПроверкаИмя.Структура[0];
						ПроверкаКолич = ПроверкаКолич[0].Структура;				
					Исключение
						Прервать;
					КонецПопытки;
					
				КонецЦикла;
				
				Если ПроверкаИмя.Имя = "ПредприятиеП" Тогда
					НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0].Имя = "ПериодПФ";
					ПроверкаИмя.Имя = "ПредприятиеПФ";				
				КонецЕсли;
				
				Если НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура.Количество() Тогда
					ПроверкаИмя = НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура[0];
					ПроверкаКолич = НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура;
					
					Если ПроверкаИмя.Имя = "ПодразделениеП" Тогда
						НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0].Имя = "ПериодПФ";
						ПроверкаИмя.Имя = "ПодразделениеПФ";
					ИначеЕсли ПроверкаИмя.Имя = "ВидП" Тогда
						НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0].Имя = "ПериодПФ";
						ПроверкаИмя.Имя = "ВидПФ";				
					КонецЕсли;
					
					Если НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура[0].Структура.Количество() Тогда
						ПроверкаИмя = НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура[0].Структура[0];
						ПроверкаКолич = НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура[0].Структура;
						
						Если ПроверкаИмя.Имя = "ВидП" Тогда
							НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0].Имя = "ПериодПФ";
							ПроверкаИмя.Имя = "ВидПФ";				
						КонецЕсли;

					КонецЕсли;
				КонецЕсли;
				
				//для горихонтального вида
				ПроверкаИмя = НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0];
				ПроверкаКолич = НастройкиДляКомпоновкиМакета.Структура[1].Колонки;
				
				Пока НЕ ПроверкаИмя.Имя = "ПериодГор" ИЛИ НЕ ПроверкаКолич.Количество() Цикл
					
					Попытка
						ПроверкаИмя = ПроверкаИмя.Структура[0];
						ПроверкаКолич = ПроверкаКолич[0].Структура;				
					Исключение
						Прервать;
					КонецПопытки;
					
				КонецЦикла;
				
				Если ПроверкаИмя.Имя = "ПериодГор" Тогда
					НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0].Имя = "ПериодГорПФ";
					ПроверкаИмя.Имя = "ПериодГорПФ";				
					НастройкиДляКомпоновкиМакета.Структура[1].Строки[1].Имя = "ВидПФ";
				КонецЕсли;
				
				НастройкиДляКомпоновкиМакета.Выбор.Элементы[1].Использование = Истина;
				НастройкиДляКомпоновкиМакета.Выбор.Элементы[2].Использование = Истина;
			Иначе
				ТекЭлемент.Значение = Справочники.СценарииПланирования.ПустаяСсылка();
			КонецЕсли;
			
			ТекЭлемент.Использование = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
		
	//для горизонтального вида меняем группировку компоновки в зависимости от представления
	Попытка
		НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0].ПоляГруппировки.Элементы[1].Поле = Новый ПолеКомпоновкиДанных(Представление);
		НастройкиДляКомпоновкиМакета.Структура[1].Колонки[0].ПоляГруппировки.Элементы[2].Использование = ПоПодразделениям;
	Исключение
	
	КонецПопытки;
	
	// подразделения для вертикального варианта
	Попытка
		ГруппировкаПодразделения = НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура[0];
		
		Если ГруппировкаПодразделения.Имя = "ПодразделениеП" Или ГруппировкаПодразделения.Имя = "ПодразделениеПФ" Тогда
			НастройкиДляКомпоновкиМакета.Структура[1].Строки[0].Структура[0].Состояние = ?(ПоПодразделениям, СостояниеЭлементаНастройкиКомпоновкиДанных.Включен, СостояниеЭлементаНастройкиКомпоновкиДанных.Отключен);
		КонецЕсли;
		
	Исключение
	КонецПопытки;
	
	НастройкиДляКомпоновкиМакета.Выбор.Элементы[0].Заголовок = Строка(Сценарий1);
	НастройкиДляКомпоновкиМакета.Выбор.Элементы[1].Заголовок = Строка(Сценарий2);
	
	сабОбщегоНазначения.сабПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, СКД, НастройкиДляКомпоновкиМакета);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиДляКомпоновкиМакета, ДанныеРасшифровки, Неопределено);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	СтандартнаяОбработка = Ложь;
	
	
КонецПроцедуры

Процедура СформироватьТекстЗапросаОстатков(ПараметрКоманды, СКД)
	
	НужныйНабор = СКД.НаборыДанных.Остатки;
	
	ТекДата = ПараметрКоманды.Период.ДатаНачала;
	ТЗ = Новый ТаблицаЗначений;
	ТекстЗапроса = "";
	
	Пока ТекДата < ПараметрКоманды.Период.ДатаОкончания Цикл
		
		Если ПараметрКоманды.Интервал = "Месяц" Тогда
			КонДата = Мин(КонецМесяца(ТекДата), ПараметрКоманды.Период.ДатаОкончания);
		ИначеЕсли ПараметрКоманды.Интервал = "Квартал" Тогда	
			КонДата = Мин(КонецКвартала(ТекДата), ПараметрКоманды.Период.ДатаОкончания); 
		ИначеЕсли ПараметрКоманды.Интервал = "Год" Тогда	
			КонДата = Мин(КонецГода(ТекДата), ПараметрКоманды.Период.ДатаОкончания);
		КонецЕсли;
		
		Если НЕ ТекДата = НачалоМесяца(ПараметрКоманды.Период.ДатаНачала) Тогда
			НовыйКусокЗапроса = СтрЗаменить(НужныйНабор.Запрос, "ВЫБРАТЬ РАЗРЕШЕННЫЕ", "ВЫБРАТЬ");
		Иначе
			НовыйКусокЗапроса = НужныйНабор.Запрос;	
		КонецЕсли;
		
		НовыйКусокЗапроса = СтрЗаменить(НовыйКусокЗапроса, "&НачалоПериода", "ДАТАВРЕМЯ(" + Формат (Год(ТекДата), "ЧГ=0") + " , " + Месяц(ТекДата) + ", " + День(ТекДата) + ", 0,0,0)");
		НовыйКусокЗапроса = СтрЗаменить(НовыйКусокЗапроса, "&КонецПериода", "ДАТАВРЕМЯ(" + Формат(Год(КонДата), "ЧГ=0") + " , " + Месяц(КонДата) + ", " + День(КонДата) + ", 23,59,59)");
		ТекстЗапроса = ТекстЗапроса + НовыйКусокЗапроса + "
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|";	
		
		Если ПараметрКоманды.Интервал = "Месяц" Тогда
			ТекДата = ДобавитьМесяц(ТекДата, 1);	
		ИначеЕсли ПараметрКоманды.Интервал = "Квартал" Тогда	
			ТекДата = ДобавитьМесяц(ТекДата, 3);	
		ИначеЕсли ПараметрКоманды.Интервал = "Год" Тогда	
			ТекДата = ДобавитьМесяц(ТекДата, 12);	
		КонецЕсли;
		
	КонецЦикла;
		
	ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 15); 
	
	// ищем последнее вхождение "ИЗ" в строку с текстом запроса
    МассивПодстрокЗапросаОстатков = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ТекстЗапроса, "//#");	
	МассивПодстрокЗапросаОстатков[0] = СтрЗаменить(МассивПодстрокЗапросаОстатков[0], "ИЗ", "ПОМЕСТИТЬ ВТ_Данные 
	| ИЗ");
	ТекстЗапросаОстатков = сабОбщегоНазначенияКлиентСервер.ПолучитьСтрокуИзМассиваПодстрок(МассивПодстрокЗапросаОстатков, "//#");
	
	ТекстЗапросаПересчетаВалюты = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Сумма(ВТ_Данные.СуммаНачальныйОстаток) КАК СуммаНачальныйОстаток,
	|	Сумма(ВТ_Данные.СуммаНачальныйОстаток1) КАК СуммаНачальныйОстаток1,
	|	ВТ_Данные.Пери КАК Пери,
	|	ВТ_Данные.Предприятие КАК Предприятие,
	|	ВТ_Данные.Период КАК Период,
	|	ВТ_Данные.Предприятия КАК Предприятия,
	|	Сумма(ВТ_Данные.СуммаКонечныйОстаток) КАК СуммаКонечныйОстаток,
	|	Сумма(ВТ_Данные.СуммаКонечныйОстаток1) КАК СуммаКонечныйОстаток1,
	|	ВТ_Данные.Подразделения КАК Подразделения,
	|	ВТ_Данные.Подразделение КАК Подразделение
	|ИЗ
	|	ВТ_Данные КАК ВТ_Данные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаКурса {(&ДатаКурса)},) КАК КурсыВалютСрезПоследних
	|		ПО ВТ_Данные.Предприятия.ОсновнаяВалютаУчета = КурсыВалютСрезПоследних.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&ДатаКурса {(&ДатаКурса)}, Валюта = &ЭквивалентнаяВалюта) КАК КурсЭквивалентнойВалюты
	|		ПО ВТ_Данные.Предприятия.ОсновнаяВалютаУчета = Неопределено
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Б_ПлановыеКурсыВалют.СрезПоследних(
	|				&ДатаКурсаБюджСц1 {(&ДатаКурсаБюджСц1)},
	|				Сценарий = &Сценарий1
	|					И Валюта2 = &ЭквивалентнаяВалюта) КАК Б_ПлановыеКурсыВалютСрезПоследних1
	|		ПО ВТ_Данные.Предприятия.ОсновнаяВалютаУчета = Б_ПлановыеКурсыВалютСрезПоследних1.Валюта1
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Б_ПлановыеКурсыВалют.СрезПоследних(
	|				&ДатаКурсаБюджСц2 {(&ДатаКурсаБюджСц2)},
	|				Сценарий = &Сценарий2
	|					И Валюта2 = &ЭквивалентнаяВалюта) КАК Б_ПлановыеКурсыВалютСрезПоследних2
	|		ПО ВТ_Данные.Предприятия.ОсновнаяВалютаУчета = Б_ПлановыеКурсыВалютСрезПоследних2.Валюта1
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Б_ПлановыеКурсыВалют.СрезПоследних(
	|				&ДатаКурсаБюджСц1 {(&ДатаКурсаБюджСц1)},
	|				Сценарий = &Сценарий1
	|					И Валюта1 = &ЭквивалентнаяВалюта) КАК ПлановыйКурсЭквивалентнойВалюты1
	|		ПО ВТ_Данные.Предприятия.ОсновнаяВалютаУчета = ПлановыйКурсЭквивалентнойВалюты1.Валюта2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Б_ПлановыеКурсыВалют.СрезПоследних(
	|				&ДатаКурсаБюджСц2 {(&ДатаКурсаБюджСц2)},
	|				Сценарий = &Сценарий2
	|					И Валюта1 = &ЭквивалентнаяВалюта) КАК ПлановыйКурсЭквивалентнойВалюты2
	|		ПО ВТ_Данные.Предприятия.ОсновнаяВалютаУчета = ПлановыйКурсЭквивалентнойВалюты2.Валюта2
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Данные.Пери,
	|	ВТ_Данные.Предприятие,
	|	ВТ_Данные.Период,
	|	ВТ_Данные.Предприятия,
	|	ВТ_Данные.Подразделения,
	|	ВТ_Данные.Подразделение";

		
	ТекстЗапросаОстатков = ТекстЗапросаОстатков + "
	| ;";
	ТекстЗапросаОстатков = ТекстЗапросаОстатков + ТекстЗапросаПересчетаВалюты;
	
	СКД.НаборыДанных.Остатки.Запрос = ТекстЗапросаОстатков;
	
	//заменяем интервалы
	СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "Месяц", ПараметрКоманды.Интервал);
	СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "Месяц", ПараметрКоманды.Интервал);

	//заменяем регистр бухгалтерии
	//Если ПараметрКоманды.Свойство("Сценарий2") Тогда
	//	
	//	Если ПараметрКоманды.Сценарий2 = Справочники.СценарииПланирования.Факт Тогда
	//		СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный", "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный");
	//		//СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "ОстаткиДенег2.Предприятия", "ОстаткиДенег2.ЦФО");
	//		СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный", "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный");
	//		//СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ДвиженияДенег2.Предприятия", "Выбор Когда ДвиженияДенег2.ЦФО = Значение(Справочник.Предприятия.ПустаяСсылка) Тогда ДвиженияДенег2.Предприятия Иначе ДвиженияДенег2.ЦФО конец");
	//		//СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ДвиженияДенег2.Подразделение", "Выбор Когда ДвиженияДенег2.ПодразделениеЦФО = Значение(Справочник.СтруктураПредприятия.ПустаяСсылка) Тогда ДвиженияДенег2.Подразделение Иначе ДвиженияДенег2.ПодразделениеЦФО конец");
	//		СКД.НаборыДанных.ОстаткиКрайние.Запрос = СтрЗаменить(СКД.НаборыДанных.ОстаткиКрайние.Запрос, "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный", "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный");
	//		//СКД.НаборыДанных.ОстаткиКрайние.Запрос = СтрЗаменить(СКД.НаборыДанных.ОстаткиКрайние.Запрос, "ОстаткиДенег2.Предприятия", "ОстаткиДенег2.ЦФО");
	//		СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос = СтрЗаменить(СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос, "РегистрБухгалтерии.Бюджетный", "РегистрБухгалтерии.Учетный");
	//		СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос = СтрЗаменить(СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос, "РегистрБухгалтерии.Бюджетный", "РегистрБухгалтерии.Учетный");
	//		//СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос = СтрЗаменить(СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос, "БюджетныйДвиженияССубконто.Предприятия", "Выбор Когда БюджетныйДвиженияССубконто.ЦФО = Значение(Справочник.Предприятия.ПустаяСсылка) Тогда БюджетныйДвиженияССубконто.Предприятия Иначе БюджетныйДвиженияССубконто.ЦФО конец");
	//		//СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос = СтрЗаменить(СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи2.Запрос, "БюджетныйДвиженияССубконто.Подразделение", "БюджетныйДвиженияССубконто.ПодразделениеЦФО");
	//	КонецЕсли;
	//	
	//КонецЕсли;
	
	//Если ПараметрКоманды.Сценарий1 = Справочники.СценарииПланирования.Факт Тогда
	//	СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "ИЗ
	//	|	РегистрБухгалтерии.Бюджетный", "ИЗ
	//	|	РегистрБухгалтерии.Учетный");                                                               
	//	СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ИЗ
	//	|	РегистрБухгалтерии.Бюджетный", "ИЗ
	//	|	РегистрБухгалтерии.Учетный");
	//	СКД.НаборыДанных.ОстаткиКрайние.Запрос = СтрЗаменить(СКД.НаборыДанных.ОстаткиКрайние.Запрос, "ИЗ
	//	|	РегистрБухгалтерии.Бюджетный", "ИЗ
	//	|	РегистрБухгалтерии.Учетный");
	//	
	//	//СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "ОстаткиДенег1.Предприятия", "ОстаткиДенег1.ЦФО");
	//	//СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ДвиженияДенег1.Предприятия", "Выбор Когда ДвиженияДенег1.ЦФО = Значение(Справочник.Предприятия.ПустаяСсылка) Тогда ДвиженияДенег1.Предприятия Иначе ДвиженияДенег1.ЦФО конец");
	//	//СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ДвиженияДенег1.Подразделение", "Выбор Когда ДвиженияДенег1.ПодразделениеЦФО = Значение(Справочник.СтруктураПредприятия.ПустаяСсылка) Тогда ДвиженияДенег1.Подразделение Иначе ДвиженияДенег1.ПодразделениеЦФО конец");
	//	//СКД.НаборыДанных.ОстаткиКрайние.Запрос = СтрЗаменить(СКД.НаборыДанных.ОстаткиКрайние.Запрос, "ОстаткиДенег1.Предприятия", "ОстаткиДенег1.ЦФО");
	//	СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи.Запрос = СтрЗаменить(СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи.Запрос, "РегистрБухгалтерии.Бюджетный", "РегистрБухгалтерии.Учетный");
	//	//СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи.Запрос = СтрЗаменить(СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи.Запрос, "БюджетныйДвиженияССубконто.Предприятия", "Выбор Когда БюджетныйДвиженияССубконто.ЦФО = Значение(Справочник.Предприятия.ПустаяСсылка) Тогда БюджетныйДвиженияССубконто.Предприятия Иначе БюджетныйДвиженияССубконто.ЦФО конец");
	//	//СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи.Запрос = СтрЗаменить(СКД.НаборыДанных.ДетЗаписи.Элементы.ДетальныеЗаписи.Запрос, "БюджетныйДвиженияССубконто.Подразделение", "БюджетныйДвиженияССубконто.ПодразделениеЦФО");
	//КонецЕсли;
	
КонецПроцедуры

