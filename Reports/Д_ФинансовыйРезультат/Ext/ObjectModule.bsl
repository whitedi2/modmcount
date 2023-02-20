﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	Если БюджетныйНаСервере.РольДоступнаСервер("БюджетныйОтдел") Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	ДокументРезультат.Очистить();
	
	ПараметрыОтчета = Новый Структура;
	
	Для Каждого ЭлементНастройки из КомпоновщикНастроек.ПользовательскиеНастройки.Элементы цикл
		
		Если ТипЗнч(ЭлементНастройки) = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") тогда
			
			если Строка(ЭлементНастройки.Параметр) = "ВыбПериод" тогда
				ПараметрыОтчета.Вставить("ВыбПериод", ЭлементНастройки.Значение);
	
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сценарий1" тогда
				ПараметрыОтчета.Вставить("Сценарий1", ЭлементНастройки.Значение);
				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сценарий1Вариант" тогда
				ПараметрыОтчета.Вставить("Сценарий1Вариант", ЭлементНастройки.Значение);
				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сценарий2" тогда
				ПараметрыОтчета.Вставить("Сценарий2", ЭлементНастройки.Значение);
				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Интервал" тогда
				ПараметрыОтчета.Вставить("Интервал", ЭлементНастройки.Значение);;
				
			ИначеЕсли Строка(ЭлементНастройки.Параметр) = "Сводный" тогда
				ПараметрыОтчета.Вставить("Сводный", ЭлементНастройки.Значение);;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СКД = ЭтотОбъект.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	СформироватьТекстЗапросаОстатков(ПараметрыОтчета, СКД);
	
	ПараметрВывода = КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВертикальноеРасположениеОбщихИтогов"); 
	
	ИнтервалМеньше = БюджетныйНаСервере.ИнтервалМеньшеПериода(ПараметрыОтчета.ВыбПериод, ПараметрыОтчета.Интервал);
	
	если ИнтервалМеньше тогда
		ПараметрВывода.Значение = РасположениеИтоговКомпоновкиДанных.Конец;
	иначе
		ПараметрВывода.Значение = РасположениеИтоговКомпоновкиДанных.Нет;
	КонецЕсли;
	
	Источник = новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД);
	КомпоновщикНастроек2 = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек2.Инициализировать(Источник);
	КомпоновщикНастроек2.ЗагрузитьНастройки(КомпоновщикНастроек.Настройки);
	КомпоновщикНастроек2.ЗагрузитьПользовательскиеНастройки(КомпоновщикНастроек.ПользовательскиеНастройки);
	
	НастройкиДляКомпоновкиМакета = КомпоновщикНастроек2.ПолучитьНастройки();
	                                                 НайтиЭлементСтруктурыНастроек(КомпоновщикНастроек.ПользовательскиеНастройки
	Для Каждого ТекЭлемент Из НастройкиДляКомпоновкиМакета.ПараметрыДанных.Элементы Цикл
		
		Если Строка(ТекЭлемент.Параметр) = "Период" Тогда
			ТекЭлемент.Значение = ПараметрыОтчета.ВыбПериод.ДатаОкончания
		КонецЕсли;
		
		Если Строка(ТекЭлемент.Параметр) = "НачалоПериода" Тогда
			ТекЭлемент.Значение = ПараметрыОтчета.ВыбПериод.ДатаНачала
		КонецЕсли;
		
		Если Строка(ТекЭлемент.Параметр) = "КонецПериода" Тогда
			ТекЭлемент.Значение = ПараметрыОтчета.ВыбПериод.ДатаОкончания
		КонецЕсли;
		
		Если Строка(ТекЭлемент.Параметр) = "ДатаНач" Тогда
			ТекЭлемент.Значение = ПараметрыОтчета.ВыбПериод.ДатаНачала
		КонецЕсли;
		
		Если Строка(ТекЭлемент.Параметр) = "ДатаКон" Тогда
			ТекЭлемент.Значение = ПараметрыОтчета.ВыбПериод.ДатаОкончания
		КонецЕсли;
		
		ПараметрТекущийВариант = НастройкиДляКомпоновкиМакета.ПараметрыДанных.Элементы.Найти("ТекущийВариант");
		//ПоПодразделениям = НастройкиДляКомпоновкиМакета.ПараметрыДанных.Элементы.Найти("ПоПодразделениям").Значение;
		
		Если Строка(ТекЭлемент.Параметр) = "Сценарий2" тогда
			
			Если ЗначениеЗаполнено(ТекЭлемент.Значение) И ТекЭлемент.Использование Тогда
				
				Если ПараметрТекущийВариант <> Неопределено И ПараметрТекущийВариант.Значение = "ГоризонтальныйСРасшифровками" Тогда
					НастройкиДляКомпоновкиМакета.Структура[0].Колонки[0].Имя = "ПодразделениеГорПФ";
					НастройкиДляКомпоновкиМакета.Структура[0].Строки[0].Структура[0].Имя = "СтатьяПФ";
					НастройкиДляКомпоновкиМакета.Структура[0].Строки[0].Структура[0].Структура[0].Имя = "КомСтатьяПФ";
					НастройкиДляКомпоновкиМакета.Структура[0].Строки[0].Структура[0].Структура[0].Структура[0].Имя = "СодержаниеПФ";
				Иначе
					
					Суффикс = "";
					Если СтрНайти(НастройкиДляКомпоновкиМакета.Структура[0].Колонки[0].Имя, "БезЕд") Тогда
						Суффикс = "БезЕд";
					КонецЕсли;
					
					НастройкиДляКомпоновкиМакета.Структура[0].Колонки[0].Имя = "ПериодПФ" + Суффикс;					
					ПроверкаИмя = НастройкиДляКомпоновкиМакета.Структура[0].Строки[0].Структура[0];
					ПроверкаКолич = НастройкиДляКомпоновкиМакета.Структура[0].Строки[0].Структура;
					ЕстьГруппировкаНоменклатуры = Истина;
					
					Пока НЕ ПроверкаИмя.Имя = "НоменклатураП" ИЛИ НЕ ПроверкаКолич.Количество() Цикл
						
						Попытка
							ПроверкаИмя = ПроверкаИмя.Структура[0];
							ПроверкаКолич = ПроверкаКолич[0].Структура;				
						Исключение
							ЕстьГруппировкаНоменклатуры = Ложь;
							Прервать;
						КонецПопытки;
						
					КонецЦикла;
					
					Если ЕстьГруппировкаНоменклатуры И ПроверкаИмя.Имя = "НоменклатураП" Тогда
						ПроверкаИмя.Имя = "НоменклатураПФ";				
					КонецЕсли;
					
				КонецЕсли;
				
				НастройкиДляКомпоновкиМакета.Выбор.Элементы[1].Использование = Истина;
				НастройкиДляКомпоновкиМакета.Выбор.Элементы[2].Использование = Истина;	
			Иначе	
				ТекЭлемент.Значение = Справочники.СценарииПланирования.ПустаяСсылка();	
			КонецЕсли;
			
			ТекЭлемент.Использование = Истина;	
		КонецЕсли;
		
		Если Строка(ТекЭлемент.Параметр) = "ЭквивалентнаяВалюта" Тогда
			СтандартныеОтчетыКлиентСервер.УстановитьПараметр(НастройкиДляКомпоновкиМакета, "ЭквивалентнаяВалюта", ?(ЗначениеЗаполнено(ТекЭлемент.Значение), ТекЭлемент.Значение, УЧ_Сервер.НациональнаяВалюта()));
		КонецЕсли;	
		
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиДляКомпоновкиМакета, ДанныеРасшифровки, Неопределено);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки);    
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
	
	//пересчет затрат на единицу
	ПересчетНаЕдиницу(ДокументРезультат);
	
	СтандартнаяОбработка = Ложь;
	
	//КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиДляКомпоновкиМакета);

	Если БюджетныйНаСервере.РольДоступнаСервер("БюджетныйОтдел") Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура СформироватьТекстЗапросаОстатков(ПараметрКоманды, СКД)
	
	//НужныйНабор = СКД.НаборыДанных.Остатки;
	//
	//ТекДата = НачалоМесяца(ПараметрКоманды.Период.ДатаНачала);
	//ТЗ = Новый ТаблицаЗначений;
	ТекстЗапроса = "";
	//Пока ТекДата < ПараметрКоманды.Период.ДатаОкончания Цикл
	//	
	//	Если ПараметрКоманды.Интервал = "Месяц" Тогда
	//		КонДата = КонецМесяца(ТекДата); 
	//	ИначеЕсли ПараметрКоманды.Интервал = "Квартал" Тогда	
	//		КонДата = КонецКвартала(ТекДата); 
	//	ИначеЕсли ПараметрКоманды.Интервал = "Год" Тогда	
	//		КонДата = КонецГода(ТекДата); 
	//	КонецЕсли;
	//	Если НЕ ТекДата = НачалоМесяца(ПараметрКоманды.Период.ДатаНачала) Тогда
	//		НовыйКусокЗапроса = СтрЗаменить(НужныйНабор.Запрос, "ВЫБРАТЬ РАЗРЕШЕННЫЕ", "ВЫБРАТЬ");
	//	Иначе
	//		НовыйКусокЗапроса = НужныйНабор.Запрос;	
	//	КонецЕсли;
	//	НовыйКусокЗапроса = СтрЗаменить(НовыйКусокЗапроса, "&НачалоПериода", "ДАТАВРЕМЯ(" + Формат (Год(ТекДата), "ЧГ=0") + " , " + Месяц(ТекДата) + ", " + День(ТекДата) + ", 0,0,0)");
	//	НовыйКусокЗапроса = СтрЗаменить(НовыйКусокЗапроса, "&КонецПериода", "ДАТАВРЕМЯ(" + Формат(Год(КонДата), "ЧГ=0") + " , " + Месяц(КонДата) + ", " + День(КонДата) + ", 23,59,59)");
	//	ТекстЗапроса = ТекстЗапроса + НовыйКусокЗапроса + "
	//	|
	//	|ОБЪЕДИНИТЬ ВСЕ
	//	|";	
	//	
	//	Если ПараметрКоманды.Интервал = "Месяц" Тогда
	//		ТекДата = ДобавитьМесяц(ТекДата, 1);	
	//	ИначеЕсли ПараметрКоманды.Интервал = "Квартал" Тогда	
	//		ТекДата = ДобавитьМесяц(ТекДата, 3);	
	//	ИначеЕсли ПараметрКоманды.Интервал = "Год" Тогда	
	//		ТекДата = ДобавитьМесяц(ТекДата, 12);	
	//	КонецЕсли;
	//КонецЦикла;
	//ТекстЗапроса = Лев(ТекстЗапроса, СтрДлина(ТекстЗапроса) - 15); 
	
	//СКД.НаборыДанных.Остатки.Запрос = ТекстЗапроса;
	
	//заменяем интервалы
	// закомментированно чтобы вытащить регистратор {
	//СКД.НаборыДанных.НаборДанных1.Запрос = СтрЗаменить(СКД.НаборыДанных.НаборДанных1.Запрос, "Месяц", ПараметрКоманды.Интервал);
	//СКД.НаборыДанных.НаборДанных2.Запрос = СтрЗаменить(СКД.НаборыДанных.НаборДанных2.Запрос, "Месяц", ПараметрКоманды.Интервал);
	//}
	
	////заменяем регистр бухгалтерии
	//Если ПараметрКоманды.Свойство("Сценарий2") Тогда
	//	Если ПараметрКоманды.Сценарий2 = Справочники.СценарииПланирования.Факт Тогда
	//		СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный", "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный");
	//		СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "ОстаткиДенег2.Предприятия", "ОстаткиДенег2.ЦФО");
	//		СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный", "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный");
	//		СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ДвиженияДенег2.Предприятия", "ДвиженияДенег2.ЦФО");
	//		СКД.НаборыДанных.ОстаткиКрайние.Запрос = СтрЗаменить(СКД.НаборыДанных.ОстаткиКрайние.Запрос, "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный", "ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный");
	//		СКД.НаборыДанных.ОстаткиКрайние.Запрос = СтрЗаменить(СКД.НаборыДанных.ОстаткиКрайние.Запрос, "ОстаткиДенег2.Предприятия", "ОстаткиДенег2.ЦФО");
	//	КонецЕсли;
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
	//	СКД.НаборыДанных.Остатки.Запрос = СтрЗаменить(СКД.НаборыДанных.Остатки.Запрос, "ОстаткиДенег1.Предприятия", "ОстаткиДенег1.ЦФО");
	//	СКД.НаборыДанных.Обороты.Запрос = СтрЗаменить(СКД.НаборыДанных.Обороты.Запрос, "ДвиженияДенег1.Предприятия", "ДвиженияДенег1.ЦФО");
	//	СКД.НаборыДанных.ОстаткиКрайние.Запрос = СтрЗаменить(СКД.НаборыДанных.ОстаткиКрайние.Запрос, "ОстаткиДенег1.Предприятия", "ОстаткиДенег1.ЦФО");
	//КонецЕсли;
	
	
	
КонецПроцедуры

Процедура ПересчетНаЕдиницу(Результат)
	
	//считаем текущее сальдо расчетным методом
	ТекСтолбец = 3;
	
	ТекЗначение = Результат.Область("R1C3").Текст;
	ТекЗначениеОтклоенние = Результат.Область("R1C2").Текст;
	ТекЗначениеЦвет = Результат.Область("R1C3").ЦветФона;
	КоличествоПустыхСтолбцовПодряд = 0;
	КоличествоВерхнейГруппировки = 0;
	ИтогоКоличество = 0;
	
	Пока КоличествоПустыхСтолбцовПодряд < 2 Цикл
		
		ТекСтрока = 1;
		КоличествоПустыхСтрокПодряд = 0;
		ЭтоСтолбецОтклонение = Ложь;
		ТекЗначениеЦвет = Неопределено;
		
		ЦветРассчета = Новый Цвет(249,243,229);
		ЦветРассчета2 = Новый Цвет(248,243,216);
		
		Пока КоличествоПустыхСтрокПодряд < 50 Цикл  // НЕ ТекЗначение = "Обороты за период и сальдо на конец" И
			Если Строка(ТекЗначениеЦвет) = "стиль: Линия отчета" Или ТекЗначениеЦвет = ЦветРассчета Или ТекЗначениеЦвет = ЦветРассчета2 Тогда
				
				Если ЗначениеЗаполнено(ТекЗначение) Тогда
					Количество = Число(ТекЗначение);
				Иначе
					Количество = 0;			
				КонецЕсли;
				
				КоличествоПустыхСтрокПодряд = 0;
				КоличествоПустыхСтолбцовПодряд = 0;
				Сумма = Истина;
				
				Пока КоличествоПустыхСтрокПодряд < 50 Цикл
					ТекСтрока = ТекСтрока + 1;
					ТекЗначение = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец, "ЧГ=0")).Текст;
					ТекЗначениеЦвет = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец, "ЧГ=0")).ЦветФона;
					Если Строка(ТекЗначениеЦвет) = "стиль: Линия отчета" Или ТекЗначениеЦвет = ЦветРассчета Или ТекЗначениеЦвет = ЦветРассчета2 Тогда
						ТекСтрока = ТекСтрока - 1;
						//доп рассчет для двойных группировок
						Если Строка(Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец, "ЧГ=0")).ЦветФона) = "стиль: Линия отчета" Тогда
							КоличествоВерхнейГруппировки = Количество;
							ЦветВерхнГруппировки = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец-1, "ЧГ=0")).ЦветФона;
							ИтогоКоличество = ИтогоКоличество + КоличествоВерхнейГруппировки;
						КонецЕсли;
						Прервать;				
					КонецЕсли;
					Если ЗначениеЗаполнено(ТекЗначение) Тогда
						Сумма = Число(ТекЗначение);

					Иначе
						Сумма = 0;
						КоличествоПустыхСтрокПодряд = КоличествоПустыхСтрокПодряд + 1;
					КонецЕсли;
					
					ЗначениеНаЕд = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст;
					Если ЗначениеЗаполнено(ЗначениеНаЕд) Тогда
						Если ЭтоСтолбецОтклонение Тогда
							
							СуммаЕдТекст1 = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 3, "ЧГ=0")).Текст;
							Если ЗначениеЗаполнено(СуммаЕдТекст1) Тогда
								СуммаЕд1 = Число(СуммаЕдТекст1);
							Иначе
								СуммаЕд1 = 0;	
							КонецЕсли;
							СуммаЕдТекст2 = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 5, "ЧГ=0")).Текст;
							Если ЗначениеЗаполнено(СуммаЕдТекст2) Тогда
								СуммаЕд2 = Число(СуммаЕдТекст2);
							Иначе
								СуммаЕд2 = 0;	
							КонецЕсли;
							
							Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст = СуммаЕд2 - СуммаЕд1; 
						Иначе	
							Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст = ?(Количество, Сумма / Количество, 0); 
						КонецЕсли;
						
					Иначе  // добавлено 28.12.2015
						//Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст = ?(Количество, Сумма / Количество, 0);
						
						Если ЭтоСтолбецОтклонение Тогда
							
							СуммаЕдТекст1 = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 3, "ЧГ=0")).Текст;
							Если ЗначениеЗаполнено(СуммаЕдТекст1) Тогда
								СуммаЕд1 = Число(СуммаЕдТекст1);
							Иначе
								СуммаЕд1 = 0;	
							КонецЕсли;
							СуммаЕдТекст2 = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 5, "ЧГ=0")).Текст;
							Если ЗначениеЗаполнено(СуммаЕдТекст2) Тогда
								СуммаЕд2 = Число(СуммаЕдТекст2);
							Иначе
								СуммаЕд2 = 0;	
							КонецЕсли;
							
							Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст = СуммаЕд2 - СуммаЕд1; 
						//Иначе	
						//	Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст = ?(Количество, Сумма / Количество, 0); 
						КонецЕсли;
						
					КонецЕсли;
					Если ТекЗначениеЦвет = ЦветВерхнГруппировки И Не КоличествоВерхнейГруппировки = 0 Тогда
						ТекСуммаВерхнейГруппировки = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец, "ЧГ=0")).Текст;
						Если ЗначениеЗаполнено(ТекСуммаВерхнейГруппировки) Тогда
							СуммаВерхнейГруппировки = Число(ТекСуммаВерхнейГруппировки);
						Иначе
							СуммаВерхнейГруппировки = 0;
						КонецЕсли;
						Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст = ?(КоличествоВерхнейГруппировки, СуммаВерхнейГруппировки / КоличествоВерхнейГруппировки, 0);	
					КонецЕсли;	
				КонецЦикла;
			ИначеЕсли ПустаяСтрока(ТекЗначение) Тогда
				КоличествоПустыхСтрокПодряд = КоличествоПустыхСтрокПодряд + 1;
				Если ТекЗначениеОтклоенние = "Отклонение" Тогда
					ЭтоСтолбецОтклонение = Истина;
				КонецЕсли;
			КонецЕсли;
			
			ТекСтрока = ТекСтрока + 1;	
			ТекЗначениеЦвет = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец, "ЧГ=0")).ЦветФона;
			ТекЗначение = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец, "ЧГ=0")).Текст;
			ТекЗначениеОтклоенние = Результат.Область("R" + Формат(ТекСтрока, "ЧГ=0") + "C" + Формат(ТекСтолбец - 1, "ЧГ=0")).Текст;
		КонецЦикла;
		ТекСтолбец = ТекСтолбец + 2;
		КоличествоПустыхСтолбцовПодряд = КоличествоПустыхСтолбцовПодряд + 1;
	КонецЦикла; 
	//закончили считать тек сальдо
	

КонецПроцедуры

Функция НайтиЭлементСтруктурыНастроек(Настройки, Имя) Экспорт
	
	Если ТипЗнч(Настройки) = Тип("ГруппировкаКомпоновкиДанных") Или ТипЗнч(Настройки) = Тип("ТаблицаКомпоновкиДанных") Или ТипЗнч(Настройки) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		Если Настройки.Имя = Имя Тогда
			Возврат Настройки;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Или ТипЗнч(Настройки) = Тип("ГруппировкаКомпоновкиДанных") Или ТипЗнч(Настройки) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		Для Каждого ТекЭлементСтруктуры Из Настройки.Структура Цикл
			Результат = НайтиЭлементСтруктурыНастроек(ТекЭлементСтруктуры, Имя);
			Если Результат <> Неопределено Тогда
				Возврат Результат
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Настройки) = Тип("ТаблицаКомпоновкиДанных") Тогда
		Для Каждого ТекЭлементСтруктуры Из Настройки.Строки Цикл
			Результат = НайтиЭлементСтруктурыНастроек(ТекЭлементСтруктуры, Имя);
			Если Результат <> Неопределено Тогда
				Возврат Результат
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТекЭлементСтруктуры Из Настройки.Колонки Цикл
			Результат = НайтиЭлементСтруктурыНастроек(ТекЭлементСтруктуры, Имя);
			Если Результат <> Неопределено Тогда
				Возврат Результат
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Возврат Неопределено;
	
КонецФункции

//Функция рекурсивно бежит по элементам структуры (группировки, таблицы) и ищет в каждой структуре элемент отбора с заданным представлением
//Первое найденное совпадение завершает поиск
//
// Параметры:
//		Настройки     - настройки СКД, группировки, таблицы
//		Представление - искомое представление
Функция НайтиЭлементОтбораКомпоновкиДанныхПоПредставлению(Настройки, Представление) Экспорт
	
	//Ищем в текущей настройке
	Если ТипЗнч(Настройки) <> Тип("ТаблицаКомпоновкиДанных") Тогда
		Для Каждого ЭлементОтбора Из Настройки.Отбор.Элементы Цикл
			Если ЭлементОтбора.Представление = Представление Тогда
				Возврат ЭлементОтбора;
			ИначеЕсли ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Для Каждого ЭлементГруппы Из ЭлементОтбора.Элементы Цикл
					Если ЭлементГруппы.Представление = Представление Тогда
						Возврат ЭлементГруппы;                                //глубже не спускаемся, надеюсь не понадобится
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	//В текущей не нашли, ищем в подчиненных
	Если ТипЗнч(Настройки) = Тип("НастройкиКомпоновкиДанных") Или ТипЗнч(Настройки) = Тип("ГруппировкаКомпоновкиДанных") Или ТипЗнч(Настройки) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		Для Каждого ЭлементСтруктуры Из Настройки.Структура Цикл
			Результат = НайтиЭлементОтбораКомпоновкиДанныхПоПредставлению(ЭлементСтруктуры, Представление);
			Если Результат <> Неопределено Тогда
				Возврат Результат
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(Настройки) = Тип("ТаблицаКомпоновкиДанных") Тогда
		Для Каждого ЭлементСтруктуры Из Настройки.Строки Цикл
			Результат = НайтиЭлементОтбораКомпоновкиДанныхПоПредставлению(ЭлементСтруктуры, Представление);
			Если Результат <> Неопределено Тогда
				Возврат Результат
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого ЭлементСтруктуры Из Настройки.Колонки Цикл
			Результат = НайтиЭлементОтбораКомпоновкиДанныхПоПредставлению(ЭлементСтруктуры, Представление);
			Если Результат <> Неопределено Тогда
				Возврат Результат
			КонецЕсли;
		КонецЦикла;		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции
