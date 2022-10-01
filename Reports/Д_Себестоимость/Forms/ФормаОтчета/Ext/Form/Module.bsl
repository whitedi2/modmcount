﻿

&НаСервере
Функция ОпределитьКвартал(НомерМесяца)
	Если НомерМесяца / 3 <= 1 Тогда
		Возврат 1;
	ИначеЕсли НомерМесяца / 3 > 1 И НомерМесяца / 3 <= 2 Тогда 
		Возврат 2;
	ИначеЕсли  НомерМесяца / 3 > 2 И НомерМесяца / 3 <= 3 Тогда
		Возврат 3;
	ИначеЕсли НомерМесяца / 3 > 3 И НомерМесяца / 3 <= 4 Тогда
		Возврат 4;	
	КонецЕсли; 
КонецФункции // ()

&НаСервере
Функция ДобавитьЗатратыНаПростой(ТЗ, Регистр1, Регистр2, ПланСчетов1, ПланСчетов2, ДатаНач,
	ДатаКон, СписокПредприятий, СчетчикМесяцев, КоэффициентОтступа, НачалоПериода, ВсегоПериодов, КлючПериод)
	Простой = 0;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	-ЕСТЬNULL(ДанныеСценарий1.СуммаОборот, 0) КАК Сумма1,
	               |	-ЕСТЬNULL(ДанныеСценарий2.СуммаОборот, 0) КАК Сумма2,
	               |	ВЫБОР
	               |		КОГДА " + КлючПериод + "(ДанныеСценарий1.Период) ЕСТЬ NULL 
	               |			ТОГДА " + КлючПериод + "(ДанныеСценарий2.Период)
	               |		ИНАЧЕ " + КлючПериод + "(ДанныеСценарий1.Период)
	               |	КОНЕЦ КАК Период,
	               |	ВЫБОР
	               |		КОГДА ДанныеСценарий1.Субконто1 ЕСТЬ NULL 
	               |			ТОГДА ДанныеСценарий2.Субконто1
	               |		ИНАЧЕ ДанныеСценарий1.Субконто1
	               |	КОНЕЦ КАК Статья,
	               |	ВЫБОР
	               |		КОГДА ДанныеСценарий1.Субконто1.Родитель ЕСТЬ NULL 
	               |			ТОГДА ДанныеСценарий2.Субконто1.Родитель
	               |		ИНАЧЕ ДанныеСценарий1.Субконто1.Родитель
	               |	КОНЕЦ КАК Родитель1,
	               |	ВЫБОР
	               |		КОГДА ДанныеСценарий1.Предприятия ЕСТЬ NULL 
	               |			ТОГДА ДанныеСценарий2.Предприятия
	               |		ИНАЧЕ ДанныеСценарий1.Предприятия
	               |	КОНЕЦ КАК Предприятия
	               |ПОМЕСТИТЬ Затраты
	               |ИЗ
	               |	РегистрБухгалтерии." + Регистр1 + ".Обороты(
	               |			&Дата1,
	               |			&Дата2,
	               |			" + КлючПериод + ",
	               |			Счет = &Счет,
	               |			,
	               |			Предприятия В ИЕРАРХИИ (&Предприятия)
	               |				И СценарийПлана = &Сценарий1,
	               |			КорСчет В ИЕРАРХИИ (&КорСчет),
	               |			) КАК ДанныеСценарий1
	               |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии." + Регистр2 + ".Обороты(
	               |				&Дата1,
	               |				&Дата2,
	               |				" + КлючПериод + ",
	               |				Счет = &Счет2,
	               |				,
	               |				Предприятия В ИЕРАРХИИ (&Предприятия)
	               |					И СценарийПлана = &Сценарий2,
	               |				КорСчет В ИЕРАРХИИ (&КорСчет2),
	               |				) КАК ДанныеСценарий2
	               |		ПО ДанныеСценарий1.Субконто1 = ДанныеСценарий2.Субконто1
	               |			И (" + КлючПериод + "(ДанныеСценарий1.Период) = " + КлючПериод + "(ДанныеСценарий2.Период))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СтатьиЗатрат.Ссылка КАК Статья,
	               |	ЕСТЬNULL(Затраты.Сумма1, 0) КАК Сумма1,
	               |	ЕСТЬNULL(Затраты.Сумма2, 0) КАК Сумма2,
	               |	ЕСТЬNULL(Затраты.Период, 0) КАК Период,
	               |	СтатьиЗатрат.ЭтоГруппа,
	               |	Затраты.Предприятия
	               |ИЗ
	               |	Справочник.СтатьиЗатрат КАК СтатьиЗатрат
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Затраты КАК Затраты
	               |		ПО (СтатьиЗатрат.Ссылка = Затраты.Статья
	               |				ИЛИ СтатьиЗатрат.Ссылка = Затраты.Родитель1)
	               |ГДЕ
	               |	(НЕ СтатьиЗатрат.Ссылка В ИЕРАРХИИ (&ЗатратыРеализация))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	СтатьиЗатрат.Код";
	
	Запрос.УстановитьПараметр("Предприятия", СписокПредприятий);
	Запрос.УстановитьПараметр("Сценарий1", Отчет.Сценарий1);
	Запрос.УстановитьПараметр("Сценарий2", Отчет.Сценарий2);
	Запрос.УстановитьПараметр("Дата1", ДатаНач);
	Запрос.УстановитьПараметр("Дата2", ДатаКон);
	Запрос.УстановитьПараметр("Счет", ПланСчетов1.ЗатратыНаПрво);
	Запрос.УстановитьПараметр("КорСчет", ПланСчетов1.ДоходыИРасходы);
	Запрос.УстановитьПараметр("Счет2", ПланСчетов2.ЗатратыНаПрво);
	Запрос.УстановитьПараметр("КорСчет2", ПланСчетов2.ДоходыИРасходы);
	Запрос.УстановитьПараметр("ЗатратыРеализация", Справочники.СтатьиЗатрат.ЗатратыРеализация);
	//Результат = Запрос.Выполнить();
	//Выборка = Результат.Выбрать();
	
	Возврат Запрос.Выполнить();
	
КонецФункции


&НаКлиенте
Процедура ВыделитьВсе(Команда)
	Отчет.Предприятие.ЗаполнитьПометки(1);
КонецПроцедуры


&НаКлиенте
Процедура СнятьФлажки(Команда)
	Отчет.Предприятие.ЗаполнитьПометки(0);
КонецПроцедуры

&НаСервере
Функция ПолучитьСценарийФакта()
	возврат Справочники.СценарииПланирования.Факт;
КонецФункции // ()

&НаСервере
Процедура ЗаполнитьТаблицу(Парам)
	
	//при выборе сценария факта в одном из полей Сценарий
	ПланСчетов1 = ?(Отчет.Сценарий1 = Справочники.СценарииПланирования.Факт, ПланыСчетов.Учетный, ПланыСчетов.Учетный);
	ПланСчетов2 = ?(Отчет.Сценарий2 = Справочники.СценарииПланирования.Факт, ПланыСчетов.Учетный, ПланыСчетов.Учетный);
	Регистр1 = ?(Отчет.Сценарий1 = Справочники.СценарииПланирования.Факт, "Учетный", "Бюджетный");
	Регистр2 = ?(Отчет.Сценарий2 = Справочники.СценарииПланирования.Факт, "Учетный", "Бюджетный");
	
	
	//определяем таблицу значений, в которую будем вносить все значения
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Шрифт"); //1) 1-обычный, 2 - жирный, 3 - курсив
	
	ТЗ.Колонки.Добавить("Порядок");//2) для структурирования дальнейшего вывода
	ТЗ.Колонки.Добавить("Признак");//3) для уникальности строки
	//порядок и признак выступают уникальным идентификтором строки
	
	ТЗ.Колонки.Добавить("Предприятие");//4) для обозначения разных предприятий
	
	ТЗ.Колонки.Добавить("Значение");//5)
	ТЗ.Колонки.Добавить("Резерв1");
	ТЗ.Колонки.Добавить("Резерв2");
	ТЗ.Колонки.Добавить("Резерв3");
	ТЗ.Колонки.Добавить("Резерв4");
	ТЗ.Колонки.Добавить("Резерв5");
	НаборИмен = ""; ИндексКолонки = 10;
	Для Кол = 1 По 100 Цикл // добавляем заранее все колонки в ТЗ с индекса 9
		ИмяКол = "Колонка" + строка(Кол);
		НаборИмен = НаборИмен + ИмяКол + ",";
		ТЗ.Колонки.Добавить(ИмяКол);
	КонецЦикла; 
	
	
	Если НЕ ПустаяСтрока(Отчет.Сценарий1) и  НЕ ПустаяСтрока(Отчет.Сценарий2) Тогда
		Макет = Отчеты.Д_Себестоимость.ПолучитьМакет("МакетПланФакт");
	иначе
		Макет = Отчеты.Д_Себестоимость.ПолучитьМакет("Макет");
	КонецЕсли; 
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка|СтолбецНачало");
	ОбластьШапкаСтолбцы = Макет.ПолучитьОбласть("Шапка|ДанныеСтолбца");
	
	ТабДок.Очистить();
	ВставлятьРазделительСтраниц = Ложь;
	
	
	Интервал = ?(Отчет.Помесячно = Перечисления.Д_Интервал.Помесячно, 1, 
	?(Отчет.Помесячно = Перечисления.Д_Интервал.Поквартально, 3, 12));
	
	КлючПериод = ?(Отчет.Помесячно = Перечисления.Д_Интервал.Помесячно, "Месяц", ?(
	Отчет.Помесячно = Перечисления.Д_Интервал.Поквартально, "Квартал", "Год"));
	
	НачалоПериода = ?(Отчет.Помесячно = Перечисления.Д_Интервал.Помесячно, Месяц(Отчет.Период.ДатаНачала),?(
	Отчет.Помесячно = Перечисления.Д_Интервал.Поквартально, ОпределитьКвартал(Месяц(Отчет.Период.ДатаНачала)), Год(Отчет.Период.ДатаНачала)));
	
	КонецПериода = ?(Отчет.Помесячно = Перечисления.Д_Интервал.Помесячно, Месяц(Отчет.Период.ДатаОкончания),?(
	Отчет.Помесячно = Перечисления.Д_Интервал.Поквартально, ОпределитьКвартал(Месяц(Отчет.Период.ДатаОкончания)), Год(Отчет.Период.ДатаОкончания)));
	
	
	ВсегоПериодов = КонецПериода - НачалоПериода + 1;
	
	СписокПредприятий = Новый Массив;
	
	Для каждого Т Из Отчет.Предприятие Цикл
		Если Т.Пометка Тогда
			СписокПредприятий.Добавить(Т.Значение);
		КонецЕсли; 
	КонецЦикла;
	
	
	//Предпр = Т.Значение;
	ДатаНач = Отчет.Период.ДатаНачала;
	ДатаКон = Отчет.Период.ДатаОкончания;
	СчетчикМесяцев = 0;
	КоэффициентОтступа = 0;
	
	
	//считаем переменные затраты и НЗВ
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА БюджетныйОбороты.Субконто1 ЕСТЬ NULL 
	|			ТОГДА БюджетныйОбороты1.Субконто1
	|		ИНАЧЕ БюджетныйОбороты.Субконто1
	|	КОНЕЦ КАК Материал,
	|	-ЕСТЬNULL(БюджетныйОбороты.СуммаОборот, 0) КАК Сумма1,
	|	-ЕСТЬNULL(БюджетныйОбороты.КоличествоОборот, 0) КАК Количество1,
	|	-ЕСТЬNULL(БюджетныйОбороты1.СуммаОборот, 0) КАК Сумма2,
	|	-ЕСТЬNULL(БюджетныйОбороты1.КоличествоОборот, 0) КАК Количество2,
	|	ВЫБОР
	|		КОГДА БюджетныйОбороты.КорСубконто1 ЕСТЬ NULL 
	|			ТОГДА БюджетныйОбороты1.КорСубконто1
	|		ИНАЧЕ БюджетныйОбороты.КорСубконто1
	|	КОНЕЦ КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА (НЕ БюджетныйОбороты.КоличествоОборот = 0)
	|			ТОГДА БюджетныйОбороты.СуммаОборот / БюджетныйОбороты.КоличествоОборот
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Цена1,
	|	ВЫБОР
	|		КОГДА (НЕ БюджетныйОбороты1.КоличествоОборот = 0)
	|			ТОГДА БюджетныйОбороты1.СуммаОборот / БюджетныйОбороты1.КоличествоОборот
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Цена2,
	|	ВЫБОР
	|		КОГДА " + КлючПериод + "(БюджетныйОбороты.Период) ЕСТЬ NULL 
	|			ТОГДА " + КлючПериод + "(БюджетныйОбороты1.Период)
	|		ИНАЧЕ " + КлючПериод + "(БюджетныйОбороты.Период)
	|	КОНЕЦ КАК Период,
	|	ВЫБОР
	|		КОГДА БюджетныйОбороты.Предприятия ЕСТЬ NULL 
	|			ТОГДА БюджетныйОбороты1.Предприятия
	|		ИНАЧЕ БюджетныйОбороты.Предприятия
	|	КОНЕЦ КАК Предприятия
	|ИЗ
	|	РегистрБухгалтерии." + Регистр1 + ".Обороты(
	|			&Дата1,
	|			&Дата2,
	|			" + КлючПериод + ",
	|			Счет В (&Счет),
	|			,
	|			СценарийПлана = &Сценарий1
	|				И Предприятия В ИЕРАРХИИ (&Предприятия)
	|				И КорСубконто1.ТипНоменклатуры = &ТипНоменклатуры
	|				И КорСубконто2 = &ОсновноеСырье,
	|			КорСчет В (&КорСчет),
	|			) КАК БюджетныйОбороты
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии." + Регистр2 + ".Обороты(
	|				&Дата1,
	|				&Дата2,
	|				" + КлючПериод + ",
	|				Счет В (&Счет),
	|				,
	|				СценарийПлана = &Сценарий2
	|					И Предприятия В ИЕРАРХИИ (&Предприятия)
	|					И КорСубконто1.ТипНоменклатуры = &ТипНоменклатуры
	|					И КорСубконто2 = &ОсновноеСырье,
	|				КорСчет В (&КорСчет),
	|				) КАК БюджетныйОбороты1
	|		ПО БюджетныйОбороты.Субконто1 = БюджетныйОбороты1.Субконто1
	|			И (" + КлючПериод + "(БюджетныйОбороты.Период) = " + КлючПериод + "(БюджетныйОбороты1.Период))
	|			И БюджетныйОбороты.Предприятия = БюджетныйОбороты1.Предприятия";
	
	Запрос.УстановитьПараметр("Предприятия", СписокПредприятий);
	Запрос.УстановитьПараметр("Сценарий1", Отчет.Сценарий1);
	Запрос.УстановитьПараметр("Сценарий2", Отчет.Сценарий2);
	Запрос.УстановитьПараметр("Дата1", ДатаНач);
	Запрос.УстановитьПараметр("Дата2", ДатаКон);
	//ПланыСчетов.Учетный.Счет20()
	Запрос.УстановитьПараметр("Счет", ПланСчетов1.ОсновноеСырье);
	Запрос.УстановитьПараметр("КорСчет", ПланСчетов1.ОсновноеПрво);
	Запрос.УстановитьПараметр("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.ОсновнаяПродукция);
	Запрос.УстановитьПараметр("ОсновноеСырье", Справочники.СтатьиЗатрат.ЗатратыОсн);
	
	РезультатСырье = Запрос.Выполнить();
	ВыборкаСырье = РезультатСырье.Выбрать();
	
	
	
	//запрос на производимые номенклатуры
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВЫБОР
	               |		КОГДА Объем1.Субконто1 ЕСТЬ NULL 
	               |			ТОГДА Объем2.Субконто1
	               |		ИНАЧЕ Объем1.Субконто1
	               |	КОНЕЦ КАК Номенклатура,
	               |	ЕСТЬNULL(Объем1.КоличествоОборотДт, 0) КАК Объем1,
	               |	ЕСТЬNULL(Объем2.КоличествоОборот, 0) КАК Объем2,
	               |	ЕСТЬNULL(Объем2.КоличествоОборот, 0) - ЕСТЬNULL(Объем1.КоличествоОборот, 0) КАК Объем3,
	               |	ВЫБОР
	               |		КОГДА " + КлючПериод + "(Объем1.Период) ЕСТЬ NULL 
	               |			ТОГДА " + КлючПериод + "(Объем2.Период)
	               |		ИНАЧЕ " + КлючПериод + "(Объем1.Период)
	               |	КОНЕЦ КАК Период,
	               |	ВЫБОР
	               |		КОГДА Объем1.Предприятия ЕСТЬ NULL 
	               |			ТОГДА Объем2.Предприятия
	               |		ИНАЧЕ Объем1.Предприятия
	               |	КОНЕЦ КАК Предприятия
	               |ИЗ
	               |	РегистрБухгалтерии." + Регистр1 + ".Обороты(
	               |			&Дата1,
	               |			&Дата2,
	               |			" + КлючПериод + ",
	               |			Счет = &Счет,
	               |			,
	               |			Предприятия В ИЕРАРХИИ (&Предприятия)
	               |				И СценарийПлана = &Сценарий1
	               |				И Субконто1.ТипНоменклатуры = &ТипНоменклатуры,
	               |			КорСчет = &КорСчет,
	               |			) КАК Объем1
	               |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии." + Регистр2 + ".Обороты(
	               |				&Дата1,
	               |				&Дата2,
	               |				" + КлючПериод + ",
	               |				Счет = &Счет2,
	               |				,
	               |				Предприятия В ИЕРАРХИИ (&Предприятия)
	               |					И СценарийПлана = &Сценарий2
	               |					И Субконто1.ТипНоменклатуры = &ТипНоменклатуры,
	               |				КорСчет = &КорСчет2,
	               |				) КАК Объем2
	               |		ПО Объем1.Субконто1 = Объем2.Субконто1
	               |			И (" + КлючПериод + "(Объем1.Период) = " + КлючПериод + "(Объем2.Период))
	               |			И Объем1.Предприятия = Объем2.Предприятия
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Предприятия";
	
	Запрос.УстановитьПараметр("Предприятия", СписокПредприятий);
	Запрос.УстановитьПараметр("Сценарий1", Отчет.Сценарий1);
	Запрос.УстановитьПараметр("Сценарий2", Отчет.Сценарий2);
	Запрос.УстановитьПараметр("Дата1", ДатаНач);
	Запрос.УстановитьПараметр("Дата2", ДатаКон);
	Запрос.УстановитьПараметр("Счет", ПланСчетов1.ГотоваяПродукция);
	Запрос.УстановитьПараметр("КорСчет", ПланСчетов1.ВыпускПродукции);
	Запрос.УстановитьПараметр("Счет2", ПланСчетов2.ГотоваяПродукция);
	Запрос.УстановитьПараметр("КорСчет2", ПланСчетов2.ВыпускПродукции);
	Запрос.УстановитьПараметр("ТипНоменклатуры", Перечисления.ТипыНоменклатуры.ОсновнаяПродукция);
	
	
	РезультатОбъемы = Запрос.Выполнить();
	
	
	//запрос по сценарию1 на расчет себестоимости
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	-ЕСТЬNULL(ДанныеСценарий1.СуммаОборот, 0) КАК Сумма1,
	               |	-ЕСТЬNULL(ДанныеСценарий2.СуммаОборот, 0) КАК Сумма2,
	               |	ВЫБОР
	               |		КОГДА " + КлючПериод + "(ДанныеСценарий1.Период) ЕСТЬ NULL 
	               |			ТОГДА " + КлючПериод + "(ДанныеСценарий2.Период)
	               |		ИНАЧЕ " + КлючПериод + "(ДанныеСценарий1.Период)
	               |	КОНЕЦ КАК Период,
	               |	ВЫБОР
	               |		КОГДА ДанныеСценарий1.Субконто2 ЕСТЬ NULL 
	               |			ТОГДА ДанныеСценарий2.Субконто2
	               |		ИНАЧЕ ДанныеСценарий1.Субконто2
	               |	КОНЕЦ КАК Статья,
	               |	ВЫБОР
	               |		КОГДА ДанныеСценарий1.Субконто2.Родитель ЕСТЬ NULL 
	               |			ТОГДА ДанныеСценарий2.Субконто2.Родитель
	               |		ИНАЧЕ ДанныеСценарий1.Субконто2.Родитель
	               |	КОНЕЦ КАК Родитель1,
	               |	ВЫБОР
	               |		КОГДА ДанныеСценарий1.Субконто1 ЕСТЬ NULL 
	               |			ТОГДА ДанныеСценарий2.Субконто1
	               |		ИНАЧЕ ДанныеСценарий1.Субконто1
	               |	КОНЕЦ КАК Номенклатура,
	               |	ВЫБОР
	               |		КОГДА ДанныеСценарий1.Предприятия ЕСТЬ NULL 
	               |			ТОГДА ДанныеСценарий2.Предприятия
	               |		ИНАЧЕ ДанныеСценарий1.Предприятия
	               |	КОНЕЦ КАК Предприятия
	               |ПОМЕСТИТЬ Данные
	               |ИЗ
	               |	РегистрБухгалтерии." + Регистр1 + ".Обороты(
	               |			&Дата1,
	               |			&Дата2,
	               |			" + КлючПериод + ",
	               |			Счет = &Счет,
	               |			,
	               |			Предприятия В ИЕРАРХИИ (&Предприятия)
	               |				И СценарийПлана = &Сценарий1,
	               |			КорСчет = &КорСчет,
	               |			) КАК ДанныеСценарий1
	               |		ПОЛНОЕ СОЕДИНЕНИЕ РегистрБухгалтерии." + Регистр2 + ".Обороты(
	               |				&Дата1,
	               |				&Дата2,
	               |				" + КлючПериод + ",
	               |				Счет = &Счет2,
	               |				,
	               |				Предприятия В ИЕРАРХИИ (&Предприятия)
	               |					И СценарийПлана = &Сценарий2,
	               |				КорСчет = &КорСчет2,
	               |				) КАК ДанныеСценарий2
	               |		ПО ДанныеСценарий1.Субконто2 = ДанныеСценарий2.Субконто2
	               |			И (" + КлючПериод + "(ДанныеСценарий1.Период) = " + КлючПериод + "(ДанныеСценарий2.Период))
	               |			И ДанныеСценарий1.Субконто1 = ДанныеСценарий2.Субконто1
	               |			И ДанныеСценарий1.Предприятия = ДанныеСценарий2.Предприятия
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СтатьиЗатрат.Ссылка КАК Статья,
	               |	СтатьиЗатрат.ЭтоГруппа,
	               |	ЕСТЬNULL(Данные.Сумма1, 0) КАК Сумма1,
	               |	ЕСТЬNULL(Данные.Сумма2, 0) КАК Сумма2,
	               |	ЕСТЬNULL(Данные.Период, 0) КАК Период,
	               |	Данные.Номенклатура КАК Номенклатура,
	               |	Данные.Предприятия
	               |ИЗ
	               |	Справочник.СтатьиЗатрат КАК СтатьиЗатрат
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Данные КАК Данные
	               |		ПО (СтатьиЗатрат.Ссылка = Данные.Статья
	               |				ИЛИ СтатьиЗатрат.Ссылка = Данные.Родитель1)
	               |ГДЕ
	               |	(НЕ СтатьиЗатрат.Ссылка В ИЕРАРХИИ (&Ссылка))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	СтатьиЗатрат.Код,
	               |	Номенклатура";
	
	
	ЛишниеГруппыСтатей = Новый Массив;
	ЛишниеГруппыСтатей.Добавить(Справочники.СтатьиЗатрат.ЗатратыРеализация);
	ЛишниеГруппыСтатей.Добавить(Справочники.СтатьиЗатрат.УслугиУКГруппа);
	
	Запрос.УстановитьПараметр("Предприятия", СписокПредприятий);
	Запрос.УстановитьПараметр("Сценарий1", Отчет.Сценарий1);
	Запрос.УстановитьПараметр("Сценарий2", Отчет.Сценарий2);
	Запрос.УстановитьПараметр("Дата1", ДатаНач);
	Запрос.УстановитьПараметр("Дата2", ДатаКон);
	Запрос.УстановитьПараметр("Счет", ПланСчетов1.ОсновноеПрво);
	Запрос.УстановитьПараметр("КорСчет", ПланСчетов1.ВыпускПродукции);
	Запрос.УстановитьПараметр("Счет2", ПланСчетов2.ОсновноеПрво);
	Запрос.УстановитьПараметр("КорСчет2", ПланСчетов2.ВыпускПродукции);
	Запрос.УстановитьПараметр("Ссылка", ЛишниеГруппыСтатей);
	
	
	РезультатЗатраты = Запрос.Выполнить();
	//ВыборкаЗатраты = РезультатЗатраты.Выбрать();
	
	ВыборкаПростой = ДобавитьЗатратыНаПростой(ТЗ, Регистр1, Регистр2, ПланСчетов1,ПланСчетов2, 
		ДатаНач, ДатаКон, СписокПредприятий, СчетчикМесяцев, КоэффициентОтступа, НачалоПериода, ВсегоПериодов, КлючПериод);

	
	Для каждого Предпр Из СписокПредприятий Цикл
		
		ПереньНоменклатур = Новый Массив; //массив с неповторяющейся номенклатурой
		СчетчикНоменклатур = 0;
		
		//заполняем объемы
		ВыборкаОбъемы = РезультатОбъемы.Выбрать();
		СтруктураПоиска = Новый Структура("Предприятия", Предпр); 
		Пока ВыборкаОбъемы.НайтиСледующий(СтруктураПоиска) Цикл
			
			Если ПереньНоменклатур.Найти(ВыборкаОбъемы.Номенклатура) = Неопределено Тогда
				ПереньНоменклатур.Добавить(ВыборкаОбъемы.Номенклатура);
				СчетчикНоменклатур = СчетчикНоменклатур + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		
		//ВыборкаОбъемы = РезультатОбъемы.Выбрать();
		Для каждого Номенклатура Из ПереньНоменклатур Цикл
			
			Объем1 = Новый Массив(60);
			Объем2 = Новый Массив(60);
			
			//вывод объемов производства;
			СтруктураВыбораОбъемы = Новый Структура("Номенклатура, Предприятия", Номенклатура, Предпр);
			ВыборкаОбъемы = РезультатОбъемы.Выбрать();
			Пока ВыборкаОбъемы.НайтиСледующий(СтруктураВыбораОбъемы) Цикл
				СчетчикМесяцев = ВыборкаОбъемы.Период - НачалоПериода + 1;
				КоэффициентОтступа = ?(ПустаяСтрока(Отчет.Сценарий2), 0, СчетчикМесяцев * 2 - 2);
				
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 1;
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = Строка(Номенклатура) + строка("Объем производства");
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = "Объем производства " + Строка(Номенклатура);
				НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] = ВыборкаОбъемы.Объем1;
				НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = ВыборкаОбъемы.Объем2;
				
				Объем1[СчетчикМесяцев] = ВыборкаОбъемы.Объем1;
				Объем2[СчетчикМесяцев] = ВыборкаОбъемы.Объем2;
			КонецЦикла;
			
			
			
			
			//очищаем массив и присваиваем числовой тип
			Сырье1 = Новый Массив(50);
			Сырье2 = Новый Массив(50);
			Переработка1 = Новый Массив(50);
			Переработка2 = Новый Массив(50);
			Итого1 = Новый Массив(50);
			Итого2 = Новый Массив(50);
			Для т = 0 По 49 Цикл
				Сырье1[т] = 0;
				Сырье2[т] = 0;
				Переработка1[т] = 0;
				Переработка2[т] = 0;
				Итого1[т] = 0;
				Итого2[т] = 0;
			КонецЦикла;
			//Номенклатура2.Добавить(ВыборкаОбъемы.Номенклатура);
			Выборка = РезультатЗатраты.Выбрать();
			СтруктураПоиска = Новый Структура("Номенклатура, Предприятия", Номенклатура, Предпр);	
			Пока Выборка.НайтиСледующий(СтруктураПоиска) цикл
				
				СчетчикМесяцев = Выборка.Период - НачалоПериода + 1;
				КоэффициентОтступа = ?(ПустаяСтрока(Отчет.Сценарий2), 0, СчетчикМесяцев * 2 - 2);
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 1 - Выборка.ЭтоГруппа;
				
				Если НЕ Выборка.ЭтоГруппа Тогда
					Если Выборка.Статья = Справочники.СтатьиЗатрат.ЗатратыОсн ИЛИ
						Выборка.Статья = Справочники.СтатьиЗатрат.ЗатратыВсп Тогда
						Сырье1[СчетчикМесяцев] = Сырье1[СчетчикМесяцев] + Выборка.Сумма1;
						Сырье2[СчетчикМесяцев] = Сырье2[СчетчикМесяцев] + Выборка.Сумма2;
						НоваяСтрока[0] = 0;
					иначе
						Переработка1[СчетчикМесяцев] = Переработка1[СчетчикМесяцев] + Выборка.Сумма1; 
						Переработка2[СчетчикМесяцев] = Переработка2[СчетчикМесяцев] + Выборка.Сумма2;									
					КонецЕсли;
				КонецЕсли;
				
				
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = Строка(Номенклатура) + строка(Выборка.Статья);
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = Выборка.Статья;
				НоваяСтрока[СчетчикМесяцев * 2 + 8 + КоэффициентОтступа] = ?(Объем1[СчетчикМесяцев], Выборка.Сумма1 / Объем1[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] = Выборка.Сумма1;
				НоваяСтрока[СчетчикМесяцев * 2+ 10 + КоэффициентОтступа] = ?(Объем2[СчетчикМесяцев], Выборка.Сумма2 / Объем2[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = Выборка.Сумма2;
				
				//расшифровка по основному сырью
				Если Выборка.Статья = Справочники.СтатьиЗатрат.ЗатратыОсн Тогда
					
					ВыборкаСырье = РезультатСырье.Выбрать();
					СтруктураПоискаСтатьи = Новый Структура("Номенклатура, Период, Предприятия", Номенклатура, ВыборкаОбъемы.Период, Предпр);	
					Пока ВыборкаСырье.НайтиСледующий(СтруктураПоискаСтатьи) цикл
						НоваяСтрока = ТЗ.Добавить();
						НоваяСтрока[0] = 1;
						НоваяСтрока[1] = 2;
						НоваяСтрока[2] = Строка(Номенклатура) + строка(ВыборкаСырье.Материал);
						НоваяСтрока[3] = Предпр;
						НоваяСтрока[4] = ВыборкаСырье.Материал;
						НоваяСтрока[СчетчикМесяцев * 2 + 8 + КоэффициентОтступа] = ВыборкаСырье.Количество1;
						НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] = ?(ВыборкаСырье.Количество1, ВыборкаСырье.Цена1, ВыборкаСырье.Сумма1);
						НоваяСтрока[СчетчикМесяцев * 2+ 10 + КоэффициентОтступа] = ВыборкаСырье.Количество2;
						НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = ?(ВыборкаСырье.Количество2, ВыборкаСырье.Цена2, ВыборкаСырье.Сумма2);						
					КонецЦикла;
					
					
				КонецЕсли;
				
			КонецЦикла;
			
			//выводим Итоги
			СтруктураВыбораОбъемы = Новый Структура("Номенклатура, Предприятия", Номенклатура, Предпр);
			ВыборкаОбъемы = РезультатОбъемы.Выбрать();
			Пока ВыборкаОбъемы.НайтиСледующий(СтруктураВыбораОбъемы) Цикл
				
				СчетчикМесяцев = ВыборкаОбъемы.Период - НачалоПериода + 1;
				КоэффициентОтступа = ?(ПустаяСтрока(Отчет.Сценарий2), 0, СчетчикМесяцев * 2 - 2);
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 0;
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = Строка(Номенклатура) + "ИТОГО:";
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = "ИТОГО:";
				НоваяСтрока[СчетчикМесяцев * 2 + 8 + КоэффициентОтступа] = ?(Объем1[СчетчикМесяцев], (Сырье1[СчетчикМесяцев] + Переработка1[СчетчикМесяцев]) / Объем1[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] =Сырье1[СчетчикМесяцев] + Переработка1[СчетчикМесяцев];
				НоваяСтрока[СчетчикМесяцев * 2+ 10 + КоэффициентОтступа] = ?(Объем2[СчетчикМесяцев], (Сырье2[СчетчикМесяцев] + Переработка2[СчетчикМесяцев]) / Объем2[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = Сырье2[СчетчикМесяцев] + Переработка2[СчетчикМесяцев];
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 0;
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = Строка(Номенклатура) + "  переработка";
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = "  переработка";
				НоваяСтрока[СчетчикМесяцев * 2 + 8 + КоэффициентОтступа] = ?(Объем1[СчетчикМесяцев], (Переработка1[СчетчикМесяцев]) / Объем1[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] =Переработка1[СчетчикМесяцев];
				НоваяСтрока[СчетчикМесяцев * 2+ 10 + КоэффициентОтступа] = ?(Объем2[СчетчикМесяцев], (Переработка2[СчетчикМесяцев]) / Объем2[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = Переработка2[СчетчикМесяцев];
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 0;
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = Строка(Номенклатура) + "  затраты на сырье";
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = "  затраты на сырье";
				НоваяСтрока[СчетчикМесяцев * 2 + 8 + КоэффициентОтступа] = ?(Объем1[СчетчикМесяцев], (Сырье1[СчетчикМесяцев]) / Объем1[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] =Сырье1[СчетчикМесяцев];
				НоваяСтрока[СчетчикМесяцев * 2+ 10 + КоэффициентОтступа] = ?(Объем2[СчетчикМесяцев], (Сырье2[СчетчикМесяцев]) / Объем2[СчетчикМесяцев], 0);
				НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] =  Сырье2[СчетчикМесяцев];
			КонецЦикла;
			
			
		КонецЦикла;
		
		//считаем затраты на простой на 91 счете
		Простой = 0;
		Сум1 = 0;
		Сум2 = 0;
		СтруктураПоиска = Новый Структура("Предприятия", Предпр);
		Выборка = ВыборкаПростой.Выбрать();
		Пока Выборка.НайтиСледующий(СтруктураПоиска) Цикл
			Если НЕ ПустаяСтрока(Выборка.Сумма1) Тогда
				Сум1 = Сум1 + Выборка.Сумма1;
			КонецЕсли; 
			
			Если НЕ ПустаяСтрока(Выборка.Сумма2) Тогда
				Сум2 = Сум2 + Выборка.Сумма2;
			КонецЕсли; 
		конеццикла;
		
		Сырье1 = Новый Массив(50);
		Сырье2 = Новый Массив(50);
		Переработка1 = Новый Массив(50);
		Переработка2 = Новый Массив(50);
		
		Для т = 0 По 49 Цикл
			Сырье1[т] = 0;
			Сырье2[т] = 0;
			Переработка1[т] = 0;
			Переработка2[т] = 0;
		КонецЦикла;
		
		Если Сум1 или Сум2 Тогда
			Простой = 1;
			Выборка = ВыборкаПростой.Выбрать();
			Пока Выборка.НайтиСледующий(СтруктураПоиска) Цикл
				СчетчикМесяцев = Выборка.Период - НачалоПериода + 1;
				КоэффициентОтступа = ?(ПустаяСтрока(Отчет.Сценарий2), 0, СчетчикМесяцев * 2 - 2);
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 1;
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = "(ПРОСТОЙ)" + строка("Объем производства");
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = "Объем производства (ПРОСТОЙ)";
				
				Если Выборка.Период Тогда
					
					НоваяСтрока = ТЗ.Добавить();
					Если НЕ Выборка.ЭтоГруппа Тогда
						Если Выборка.Статья = Справочники.СтатьиЗатрат.ЗатратыОсн ИЛИ
							Выборка.Статья = Справочники.СтатьиЗатрат.ЗатратыВсп Тогда
							Сырье1[СчетчикМесяцев] = Сырье1[СчетчикМесяцев] + Выборка.Сумма1;
							Сырье2[СчетчикМесяцев] = Сырье2[СчетчикМесяцев] + Выборка.Сумма2;
						иначе
							Переработка1[СчетчикМесяцев] = Переработка1[СчетчикМесяцев] + Выборка.Сумма1; 
							Переработка2[СчетчикМесяцев] = Переработка2[СчетчикМесяцев] + Выборка.Сумма2;
						КонецЕсли;
					КонецЕсли;
					
					
					НоваяСтрока[0] = 1 - Выборка.ЭтоГруппа;
					
					Если НЕ Выборка.ЭтоГруппа И (Выборка.Статья = Справочники.СтатьиЗатрат.ЗатратыОсн ИЛИ
						Выборка.Статья = Справочники.СтатьиЗатрат.ЗатратыВсп) Тогда
						НоваяСтрока[0] = 0;
					КонецЕсли;
					
					
					НоваяСтрока[1] = 0;
					НоваяСтрока[2] = "(ПРОСТОЙ)" + строка(Выборка.Статья);
					НоваяСтрока[3] = Предпр;
					НоваяСтрока[4] = Выборка.Статья;
					НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] = Выборка.Сумма1;
					НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = Выборка.Сумма2;
					
				КонецЕсли;
				
				
			КонецЦикла;
			
			Для СчетчикМесяцев = 1 По ВсегоПериодов Цикл
				КоэффициентОтступа = ?(ПустаяСтрока(Отчет.Сценарий2), 0, СчетчикМесяцев * 2 - 2);
				
				//выводим Итоги
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 0;
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = "(ПРОСТОЙ)" + "ИТОГО:";
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = "ИТОГО:";
				НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] =Сырье1[СчетчикМесяцев] + Переработка1[СчетчикМесяцев];
				НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = Сырье2[СчетчикМесяцев] + Переработка2[СчетчикМесяцев];
				
				НоваяСтрока = ТЗ.Добавить();
				НоваяСтрока[0] = 0;
				НоваяСтрока[1] = 0;
				НоваяСтрока[2] = "(ПРОСТОЙ)" + "  переработка";
				НоваяСтрока[3] = Предпр;
				НоваяСтрока[4] = "  переработка";
				НоваяСтрока[СчетчикМесяцев * 2 + 9 + КоэффициентОтступа] =Переработка1[СчетчикМесяцев];
				НоваяСтрока[СчетчикМесяцев * 2+ 11 + КоэффициентОтступа] = Переработка2[СчетчикМесяцев];
			КонецЦикла;
			
			
		КонецЕсли;
		
		
		//выводим всего по предприятию
		Если СчетчикНоменклатур + Простой > 1  Тогда
			//ТЗ.Свернуть("Шрифт, Порядок, Признак, Предприятие, Значение", НаборИмен);
			Т32 = ТЗ;
			//считаем итого объем
			ОбъемВсего = Новый Массив(1000);
			Для Строчка = 0 По Т32.Количество()-1 Цикл
				Если Т32[Строчка][3] = Предпр И НЕ Т32[Строчка][1] Тогда
					Если Лев(Т32[Строчка][4], 18) = "Объем производства" Тогда
						Для Колонка = 5 По 10 + ВсегоПериодов * 2 * ?(ПустаяСтрока(Отчет.Сценарий2), 1, 2) Цикл
							ОбъемВсего[Колонка] =  ?(ОбъемВсего[Колонка] = Неопределено, 0, ОбъемВсего[Колонка]) + ?(Т32[Строчка][Колонка] = Неопределено, 0, Т32[Строчка][Колонка]);
						конеццикла;
					конецесли;
				КонецЕсли; 
			конеццикла;
			
			Для Строчка = 0 По Т32.Количество()-1 Цикл
				Если Т32[Строчка][3] = Предпр И НЕ Т32[Строчка][1] Тогда
					НоваяСтрока = ТЗ.Добавить();
					НоваяСтрока[0] = Т32[Строчка][0];
					НоваяСтрока[1] = Т32[Строчка][1];
					НоваяСтрока[2] = "всего  переработка";
					НоваяСтрока[3] = Т32[Строчка][3];
					Если Лев(Т32[Строчка][4], 18) = "Объем производства" Тогда
						НоваяСтрока[4] = "Объем производства (ВСЕГО)";
					иначе
						НоваяСтрока[4] = Т32[Строчка][4];
					конецесли;
					Для Колонка = 7 По 10 + ВсегоПериодов * 2 * ?(ПустаяСтрока(Отчет.Сценарий2), 1, 2) Цикл
						НоваяСтрока[Колонка - 1] = ?(ОбъемВсего[Колонка], ?(Т32[Строчка][Колонка] = Неопределено, 0, Т32[Строчка][Колонка]) / ОбъемВсего[Колонка], 0);
						НоваяСтрока[Колонка] =  Т32[Строчка][Колонка];						
						Колонка = Колонка + 1;
					конеццикла;
				КонецЕсли; 
			конеццикла;
		КонецЕсли;
		
		
	КонецЦикла; 
	
	
	//КонецЦикла;
	
	
	ТЗ.Свернуть("Шрифт, Порядок, Признак, Предприятие, Значение", НаборИмен);
	
	Если Парам = 1 Тогда //выводим ТЗ в чистом виде
		Макет = Отчеты.Д_Себестоимость.ПолучитьМакет("Таблица");
		ОбластьСтрока = Макет.ПолучитьОбласть("Строчка|Столбец");
		
		ОбластьСтрока.Параметры.Значен = ТЗ.Колонки.Получить(0).Имя;
		ТабДок.Вывести(ОбластьСтрока);
		Для Колонка = 1 По ТЗ.Колонки.Количество()-1 Цикл
			ОбластьСтрока.Параметры.Значен = ТЗ.Колонки.Получить(Колонка).Имя;
			ТабДок.Присоединить(ОбластьСтрока);
		КонецЦикла;
		
		Для Строчка = 0 По ТЗ.Количество()-1 Цикл
			ОбластьСтрока.Параметры.Значен = ТЗ[Строчка][0];
			ТабДок.Вывести(ОбластьСтрока);
			
			Для Колонка = 1 По ТЗ.Колонки.Количество()-1 Цикл
				ОбластьСтрока.Параметры.Значен = ТЗ[Строчка][Колонка];
				ТабДок.Присоединить(ОбластьСтрока);
				
			КонецЦикла;
			
			
		КонецЦикла;		
		
	иначе //обрабатываем вывод отчета
		ТабДок.НачатьАвтогруппировкуСтрок();
		Для Строчка = 0 По ТЗ.Количество()-1 Цикл
			
			Если Лев(ТЗ[Строчка][4], 18) = "Объем производства" Тогда // выводим шапку
				
				ОбластьШапка.Параметры.Номенклатура = Сред(ТЗ[Строчка][4], 20, СтрДлина(ТЗ[Строчка][4]));
				ОбластьШапка.Параметры.Предприятие = ТЗ[Строчка][3];
				ОбластьШапка.Параметры.Месяц = ПредставлениеПериода(Отчет.Период.ДатаНачала, Отчет.Период.ДатаОкончания);;
				ТабДок.Вывести(ОбластьШапка);
				Период = 0;
				Для Колонка = 1 По ВсегоПериодов * ?(ПустаяСтрока(Отчет.Сценарий2), 1, 2) Цикл
					Период = Период + Интервал;
					ОбластьШапкаСтолбцы.Параметры.Сценарий1 = Отчет.Сценарий1;
					Если ВсегоПериодов > 1 Тогда
						ОбластьШапкаСтолбцы.Параметры.Месяц = ПредставлениеПериода(НачалоМесяца(ДобавитьМесяц(Отчет.Период.ДатаНачала, Период - Интервал)), КонецМесяца(ДобавитьМесяц(Отчет.Период.ДатаНачала, Период - 1)));	
					иначе
						ОбластьШапкаСтолбцы.Параметры.Месяц = ПредставлениеПериода(Отчет.Период.ДатаНачала, Отчет.Период.ДатаОкончания);	
					КонецЕсли; 
					
					ОбластьШапкаСтолбцы.Параметры.Объем1 = ТЗ[Строчка][Колонка * 2 + 4];
					Если НЕ ПустаяСтрока(Отчет.Сценарий2)  Тогда
						ОбластьШапкаСтолбцы.Параметры.Сценарий2 = Отчет.Сценарий2;
						ОбластьШапкаСтолбцы.Параметры.Объем2 = ТЗ[Строчка][Колонка * 2 + 6];
						ОбластьШапкаСтолбцы.Параметры.Объем3 = ОбластьШапкаСтолбцы.Параметры.Объем2 - ОбластьШапкаСтолбцы.Параметры.Объем1;
						Колонка = Колонка + 1;
					КонецЕсли;
					ТабДок.Присоединить(ОбластьШапкаСтолбцы);
				КонецЦикла;
				Продолжить;
			КонецЕсли;
			
			//получаем шрифт
			ОбластьДанные = Макет.ПолучитьОбласть("Строка" + строка(ТЗ[Строчка][0]) + "|СтолбецНачало");
			ОбластьДанныеСтолбцы = Макет.ПолучитьОбласть("Строка" + строка(ТЗ[Строчка][0]) + "|ДанныеСтолбца");			
			
			//получаем данные
			ОбластьДанные.Параметры.Статья = ТЗ[Строчка][4];
			
			
			ТабДок.Вывести(ОбластьДанные, строка(ТЗ[Строчка][0]));
			Период = 0;
			Для Колонка = 1 По ВсегоПериодов * ?(ПустаяСтрока(Отчет.Сценарий2), 1, 2) Цикл
				Период = Период + Интервал;
				ОбластьДанныеСтолбцы.Параметры.Сумма11 =  ТЗ[Строчка][Колонка * 2 + 3];
				ОбластьДанныеСтолбцы.Параметры.Сумма1 =  ТЗ[Строчка][Колонка * 2 + 4];
				Если НЕ ПустаяСтрока(Отчет.Сценарий2)  Тогда
					ОбластьДанныеСтолбцы.Параметры.Сумма21 = ТЗ[Строчка][Колонка * 2 + 5];
					ОбластьДанныеСтолбцы.Параметры.Сумма2 = ТЗ[Строчка][Колонка * 2 + 6];
					ОбластьДанныеСтолбцы.Параметры.Сумма31 = ОбластьДанныеСтолбцы.Параметры.Сумма21 - ОбластьДанныеСтолбцы.Параметры.Сумма11;
					ОбластьДанныеСтолбцы.Параметры.Сумма3 = ОбластьДанныеСтолбцы.Параметры.Сумма2 - ОбластьДанныеСтолбцы.Параметры.Сумма1;
					Колонка = Колонка + 1;
				КонецЕсли;
				
				СтруктураРасшифровки = Новый Структура;
				СтруктураРасшифровки.Вставить("Отчет", "Отчеты.Д_Расшифровка");
				СтруктураРасшифровки.Вставить("Счет", ПланСчетов1.ЗатратыНаПрво);
				СтруктураРасшифровки.Вставить("Предприятие", ТЗ[Строчка][3]);
				СтруктураРасшифровки.Вставить("Субконто1", ТЗ[Строчка][4]);
				СтруктураРасшифровки.Вставить("Дата1", ?(ВсегоПериодов > 1, НачалоМесяца(ДобавитьМесяц(Отчет.Период.ДатаНачала, Период - Интервал)), Отчет.Период.ДатаНачала));
				СтруктураРасшифровки.Вставить("Дата2", ?(ВсегоПериодов > 1, КонецМесяца(ДобавитьМесяц(Отчет.Период.ДатаНачала, Период - 1)), Отчет.Период.ДатаОкончания));
				СтруктураРасшифровки.Вставить("ВидимостьШапки", 0);
				СтруктураРасшифровки.Вставить("Сценарий1", Отчет.Сценарий1);
				
				ОбластьДанныеСтолбцы.Параметры.Расшифровка = СтруктураРасшифровки;
				Если НЕ ПустаяСтрока(Отчет.Сценарий2)  Тогда
					СтруктураРасшифровки2 = Новый Структура;
					СтруктураРасшифровки2.Вставить("Отчет", "Отчеты.Д_Расшифровка");
					СтруктураРасшифровки2.Вставить("Счет", ПланСчетов2.ЗатратыНаПрво);
					СтруктураРасшифровки2.Вставить("Предприятие", ТЗ[Строчка][3]);
					СтруктураРасшифровки2.Вставить("Субконто1", ТЗ[Строчка][4]);
					СтруктураРасшифровки2.Вставить("Дата1", ?(ВсегоПериодов > 1, НачалоМесяца(ДобавитьМесяц(Отчет.Период.ДатаНачала, Период - Интервал)), Отчет.Период.ДатаНачала));
					СтруктураРасшифровки2.Вставить("Дата2", ?(ВсегоПериодов > 1, КонецМесяца(ДобавитьМесяц(Отчет.Период.ДатаНачала, Период - 1)), Отчет.Период.ДатаОкончания));
					СтруктураРасшифровки2.Вставить("ВидимостьШапки", 0);
					СтруктураРасшифровки2.Вставить("Сценарий1", Отчет.Сценарий2);
					ОбластьДанныеСтолбцы.Параметры.Расшифровка2 = СтруктураРасшифровки2;
				КонецЕсли;
				
				ТабДок.Присоединить(ОбластьДанныеСтолбцы, строка(ТЗ[Строчка][0]));
				
				//Колонка = Колонка + 1;
			КонецЦикла;
		КонецЦикла;
		ТабДок.ЗакончитьАвтогруппировкуСтрок();
	КонецЕсли; 
	
	
	//таблицу на экран
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.Защита = Ложь;
	ТабДок.ТолькоПросмотр = Истина;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
	Элементы.ТабДок.Видимость = Истина;
	
	
КонецПроцедуры


&НаКлиенте
Процедура Сформировать(Команда)
	
	ЗаполнитьТаблицу(0);
	
	
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВидимостьСпискаПредприятий = ?(БюджетныйНаСервере.ПолучитьПредприятия().Количество() > 1, 1, 0);
	Элементы.Группа2.Видимость = ВидимостьСпискаПредприятий;
	
	Группы = Новый Массив;
	Группы.Добавить(1);
	Группы.Добавить(7);
	
	БюджетныйНаСервере.ЗаполнитьСписокПредприятия(Отчет.Предприятие, Группы);
	
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьТаблицу(Команда)
	ЗаполнитьТаблицу(1);
КонецПроцедуры

&НаСервере
Процедура Расшифровать(Расшифровка)
	
	
	
КонецПроцедуры


&НаКлиенте
Процедура ТабДокОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	БюджетныйНаКлиенте.РасшифроватьСумму(Элемент, Расшифровка);		
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Сценарий1") Тогда //вызван отчет извне с параметрами
		Отчет.Сценарий1 = Параметры.Сценарий1;
		Отчет.Сценарий2 = Параметры.Сценарий2;
		Отчет.Период = Параметры.Период;
		Элементы.Группа.Видимость = Параметры.НастройкиВидимость;
		БюджетныйНаСервере.ЗаполнитьСписокПредприятия(Отчет.Предприятие, 0);
		Если ТипЗнч(Параметры.Предприятия) = Тип("Массив") ИЛИ ТипЗнч(Параметры.Предприятия) = Тип("СписокЗначений") Тогда
			Отчет.Предприятие.ЗаполнитьПометки(Истина);
		Иначе
			Отчет.Предприятие.НайтиПоЗначению(Параметры.Предприятие).Пометка = 1;		
		КонецЕсли;
		
		//Отчет.Предприятие = Параметры.Предприятие;
		ЗаполнитьТаблицу(0);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.Группа.Видимость = 1 - Элементы.Группа.Видимость;
КонецПроцедуры

&НаКлиенте
Процедура Сценарий1ПриИзменении(Элемент)
	Отчет.Период.ДатаНачала = НачалоМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий1).Дата1 + 60 * 60 * 24);
	Отчет.Период.ДатаОкончания = КонецМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий1).Дата2);
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьПериод(Команда)
	Элементы.Период.Видимость = 1 - Элементы.Период.Видимость;	
КонецПроцедуры


&НаКлиенте
Процедура Сценарий2ПриИзменении(Элемент)
	Если НЕ Отчет.Сценарий2 = ПолучитьСценарийФакта() Тогда
		Отчет.Период.ДатаНачала = НачалоМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий2).Дата1 + 60 * 60 * 24);
		Отчет.Период.ДатаОкончания = КонецМесяца(БюджетныйНаСервере.ПолучитьПериодСценария(Отчет.Сценарий2).Дата2);
	КонецЕсли;
	Если ПустаяСтрока(Отчет.Сценарий2) Тогда
		Сценарий1ПриИзменении(0);	
	КонецЕсли;
КонецПроцедуры

