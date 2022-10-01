﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	
	ДокументРезультат.Очистить();
	
	ПараметрКоманды = Новый Структура;
	
	Если ТипЗнч(КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение) = Тип("СписокЗначений") Тогда
		ТекСценарии = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение;
	Иначе
		ТекСценарии = Новый СписокЗначений;
		ТекСценарии.Добавить(КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение);
	КонецЕсли;
	
	Если ТипЗнч(КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].Значение) = Тип("СписокЗначений") Тогда
		ТекСчет = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].Значение;
	Иначе
		ТекСчет = Новый СписокЗначений;
		ТекСчет.Добавить(КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[3].Значение);
	КонецЕсли;
	
	ПараметрКоманды.Вставить("Сценарий1", ТекСценарии);
	ПараметрКоманды.Вставить("Предприятие", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[1].Значение);
	ПараметрКоманды.Вставить("Подразделение", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[2].Значение);
	ПараметрКоманды.Вставить("Счет",  ТекСчет);
	ПараметрКоманды.Вставить("Дата1", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[4].Значение.ДатаНачала);
	ПараметрКоманды.Вставить("Дата2", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[4].Значение.ДатаОкончания);
	//Попытка
	Если КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[5].Использование Тогда
		ПараметрКоманды.Вставить("Субконто1", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[5].Значение);
	Иначе
		ПараметрКоманды.Вставить("Субконто1", NULL);
	КонецЕсли;
	Если КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[6].Использование Тогда
		ПараметрКоманды.Вставить("Субконто2", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[6].Значение);
	Иначе
		ПараметрКоманды.Вставить("Субконто2", NULL);
	КонецЕсли;
	Если КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[7].Использование Тогда
		ПараметрКоманды.Вставить("СчитатьПоЦФО", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[7].Значение);
	Иначе
		ПараметрКоманды.Вставить("СчитатьПоЦФО", Ложь);
	КонецЕсли;
	//Если КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[7].Использование Тогда
	//	ПараметрКоманды.Вставить("Взаиморасчеты", КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[7].Значение);
	//Иначе
	//	ПараметрКоманды.Вставить("Взаиморасчеты", Ложь);
	//КонецЕсли;
	
	//Исключение
	//	ПараметрКоманды.Вставить("Субконто1", Null);
	//КонецПопытки;
	//Попытка
	
	//Исключение
	//	ПараметрКоманды.Вставить("Субконто2", Null);
	//КонецПопытки;
	
	//МассивПредприятий = Новый Массив;
	//Для каждого ТекПредприятие Из Предприятие Цикл
	//	Если ТекПредприятие.Пометка Тогда
	//		МассивПредприятий.Добавить(ТекПредприятие.Значение);
	//	КонецЕсли;
	//КонецЦикла; 
	//ПараметрКоманды.Вставить("Предприятие", Предприятие);
	
	
	ЗаполнитьТаблицу(ДокументРезультат, ПараметрКоманды);
	
	ДокументРезультат.ОтображатьСетку = Ложь;
	ДокументРезультат.Защита = Ложь;
	ДокументРезультат.ТолькоПросмотр = Истина;
	ДокументРезультат.ОтображатьЗаголовки = Истина;
	ДокументРезультат.ОтображатьГруппировки = Истина;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ЗаполнитьТаблицу(ТабДок, ПараметрыОтчета) Экспорт
	
	//СчетаОбхода = ПараметрыОтчета.СчетаОбхода;
	
	Т = 1;
	
	Если НЕ ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено И ПараметрыОтчета.Сценарий1.Количество() > 1 Тогда
		Сообщить("В сценарии 1 не могут присутствовать одновременно сценарии плана и факта");
		Возврат;
	КонецЕсли; 
	
	Если ТипЗнч(ПараметрыОтчета.Счет[0].Значение) = Тип("ПланСчетовСсылка.Учетный") Тогда
		ПланСчетов1 = ПланыСчетов.Учетный;
		Регистр1 = "Учетный";
		ПланСчетовЗапрос = "Учетный";
	ИначеЕсли ТипЗнч(ПараметрыОтчета.Счет[0].Значение) = Тип("ПланСчетовСсылка.Управленческий") Тогда
		ПланСчетов1 = ПланыСчетов.Учетный;
		Регистр1 = "Бюджетный";
		ПланСчетовЗапрос  = "Управленческий";
	Иначе
		ПланСчетов1 = ПланыСчетов.Казна;
		Регистр1 = "Казна";
		ПланСчетовЗапрос = "Казна";
	КонецЕсли;
	
	//ПланСчетов1 = ?(Не ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено, ПланыСчетов.Учетный, ПланыСчетов.Учетный);
	//Регистр1 = ?(ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено, "Бюджетный", "Учетный");
	//ПланСчетовЗапрос = ?(ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено, "Управленческий", "Учетный");
	
	Попытка
		ЭтотОбъект2 = ВнешниеОтчеты.Создать("Д_Расшифровка");	
	Исключение
		ЭтотОбъект2 = Отчеты.Д_Расшифровка;
	КонецПопытки;
	
	
	
	Макет = ЭтотОбъект2.ПолучитьМакет("Макет");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка1");
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьНачало = Макет.ПолучитьОбласть("Начало");
	ОбластьКонец = Макет.ПолучитьОбласть("Конец");
	ОбластьИтого = Макет.ПолучитьОбласть("Итого");
	
	ТабДок.Очистить();
	ВставлятьРазделительСтраниц = Ложь;
	
	//Счет
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Управленческий.Ссылка
	|ИЗ
	|	ПланСчетов."  + ПланСчетовЗапрос + " КАК Управленческий
	|ГДЕ
	|	Управленческий.Ссылка В ИЕРАРХИИ(&Родитель)";
	
	Запрос.УстановитьПараметр("Родитель", ПараметрыОтчета.Счет);
	
	РезультатСчета = Запрос.Выполнить();
	ВыборкаСчета = РезультатСчета.Выбрать();
	
	СчетИИ = Новый СписокЗначений;
	Пока ВыборкаСчета.Следующий() Цикл
		СчетИИ.Добавить(ВыборкаСчета.Ссылка);
	КонецЦикла;
	
	
	Запрос = Новый Запрос;
	Если Регистр1 = "Учетный" Тогда
		
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	БюджетныйДвиженияССубконто.Период КАК Период,
		               |	БюджетныйДвиженияССубконто.СчетДт,
		               |	БюджетныйДвиженияССубконто.СчетКт,
		               |	БюджетныйДвиженияССубконто.СубконтоДт1,
		               |	БюджетныйДвиженияССубконто.СубконтоДт2,
		               |	БюджетныйДвиженияССубконто.СубконтоКт1,
		               |	БюджетныйДвиженияССубконто.СубконтоКт2,
		               |	БюджетныйДвиженияССубконто.Сумма,
		               |	БюджетныйДвиженияССубконто.Содержание,
		               |	БюджетныйДвиженияССубконто.Регистратор,
		               |	БюджетныйДвиженияССубконто.НомерСтроки КАК НомерСтроки,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокДт, 0) КАК СуммаКонечныйОстатокДт,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокКт, 0) КАК СуммаКонечныйОстатокКт,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокДт, 0) КАК СуммаНачальныйОстатокДт,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокКт, 0) КАК СуммаНачальныйОстатокКт
		               |ИЗ
		               |	РегистрБухгалтерии.Учетный.ДвиженияССубконто(
		               |			&Дата1,
		               |			&Дата2,
		               |			ВЫБОР
		               |					КОГДА &Регистр = ""Учетный""
		               |						ТОГДА ВЫБОР
		               |								КОГДА &СчитатьПоЦФО = ИСТИНА
		               |									ТОГДА Предприятия В (&Предприятия)
		               |								ИНАЧЕ Предприятия В (&Предприятия)
		               |							КОНЕЦ
		               |					ИНАЧЕ Предприятия В (&Предприятия)
		               |				КОНЕЦ
		               |				И Счет В ИЕРАРХИИ (&Счет),
		               |			,
		               |			) КАК БюджетныйДвиженияССубконто
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Учетный.ОстаткиИОбороты(
		               |				&Дата1,
		               |				&Дата2,
		               |				Запись,
		               |				,
		               |				Счет В ИЕРАРХИИ (&Счет),
		               |				,
		               |				ВЫБОР
		               |						КОГДА &Регистр = ""Учетный""
		               |							ТОГДА ВЫБОР
		               |									КОГДА &СчитатьПоЦФО = ИСТИНА
		               |										ТОГДА Предприятия В (&Предприятия)
		               |									ИНАЧЕ Предприятия В (&Предприятия)
		               |								КОНЕЦ
		               |						ИНАЧЕ Предприятия В (&Предприятия)
		               |					КОНЕЦ
		               |					И ВЫБОР
		               |						КОГДА &Сценарий1Условие ЕСТЬ NULL 
		               |							ТОГДА СценарийПлана В (&Сценарий1)
		               |						ИНАЧЕ СценарийПлана В (&Сценарий1)
		               |					КОНЕЦ
		               |					И ВЫБОР
		               |						КОГДА &Субконто1 ЕСТЬ NULL 
		               |							ТОГДА ИСТИНА
		               |						ИНАЧЕ ВЫБОР
		               |								КОГДА &ПустоеСубконто1
		               |									ТОГДА Субконто1 В (&Субконто1)
		               |								ИНАЧЕ Субконто1 В ИЕРАРХИИ (&Субконто1)
		               |							КОНЕЦ
		               |					КОНЕЦ
		               |					И ВЫБОР
		               |						КОГДА &Субконто2 ЕСТЬ NULL 
		               |							ТОГДА ИСТИНА
		               |						ИНАЧЕ ВЫБОР
		               |								КОГДА &ПустоеСубконто1
		               |									ТОГДА Субконто2 В (&Субконто2)
		               |								ИНАЧЕ Субконто2 В ИЕРАРХИИ (&Субконто2)
		               |							КОНЕЦ
		               |					КОНЕЦ
		               |					И ВЫБОР
		               |						КОГДА &Подразделение ЕСТЬ NULL 
		               |							ТОГДА ИСТИНА
		               |						ИНАЧЕ ВЫБОР
		               |								КОГДА &СчитатьПоЦФО = ИСТИНА
		               |									ТОГДА Подразделение В (&Подразделение)
		               |								ИНАЧЕ Подразделение В (&Подразделение)
		               |							КОНЕЦ
		               |					КОНЕЦ) КАК БюджетныйОстаткиИОбороты
		               |		ПО БюджетныйДвиженияССубконто.Регистратор = БюджетныйОстаткиИОбороты.Регистратор
		               |			И БюджетныйДвиженияССубконто.НомерСтроки = БюджетныйОстаткиИОбороты.НомерСтроки
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Период,
		               |	НомерСтроки";
	ИначеЕсли Регистр1 = "Бюджетный" Тогда
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	БюджетныйДвиженияССубконто.Период КАК Период,
		               |	БюджетныйДвиженияССубконто.СчетДт,
		               |	БюджетныйДвиженияССубконто.СчетКт,
		               |	БюджетныйДвиженияССубконто.СубконтоДт1,
		               |	БюджетныйДвиженияССубконто.СубконтоДт2,
		               |	БюджетныйДвиженияССубконто.СубконтоКт1,
		               |	БюджетныйДвиженияССубконто.СубконтоКт2,
		               |	БюджетныйДвиженияССубконто.Сумма,
		               |	БюджетныйДвиженияССубконто.Содержание,
		               |	БюджетныйДвиженияССубконто.Регистратор,
		               |	БюджетныйДвиженияССубконто.НомерСтроки КАК НомерСтроки,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокДт, 0) КАК СуммаКонечныйОстатокДт,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокКт, 0) КАК СуммаКонечныйОстатокКт,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокДт, 0) КАК СуммаНачальныйОстатокДт,
		               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокКт, 0) КАК СуммаНачальныйОстатокКт
		               |ИЗ
		               |	РегистрБухгалтерии.Бюджетный.ДвиженияССубконто(
		               |			&Дата1,
		               |			&Дата2,
		               |			Предприятия В (&Предприятия)
		               |				И Счет В ИЕРАРХИИ (&Счет),
		               |			,
		               |			) КАК БюджетныйДвиженияССубконто
		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный.ОстаткиИОбороты(
		               |				&Дата1,
		               |				&Дата2,
		               |				Запись,
		               |				,
		               |				Счет В ИЕРАРХИИ (&Счет),
		               |				,
		               |				Предприятия В (&Предприятия)
		               |					И ВЫБОР
		               |						КОГДА &Сценарий1Условие ЕСТЬ NULL 
		               |							ТОГДА СценарийПлана В (&Сценарий1)
		               |						ИНАЧЕ СценарийПлана В (&Сценарий1)
		               |					КОНЕЦ
		               |					И ВЫБОР
		               |						КОГДА &Субконто1 ЕСТЬ NULL 
		               |							ТОГДА ИСТИНА
		               |						ИНАЧЕ ВЫБОР
		               |								КОГДА &ПустоеСубконто1
		               |									ТОГДА Субконто1 В (&Субконто1)
		               |								ИНАЧЕ Субконто1 В ИЕРАРХИИ (&Субконто1)
		               |							КОНЕЦ
		               |					КОНЕЦ
		               |					И ВЫБОР
		               |						КОГДА &Субконто2 ЕСТЬ NULL 
		               |							ТОГДА ИСТИНА
		               |						ИНАЧЕ ВЫБОР
		               |								КОГДА &ПустоеСубконто1
		               |									ТОГДА Субконто2 В (&Субконто2)
		               |								ИНАЧЕ Субконто2 В ИЕРАРХИИ (&Субконто2)
		               |							КОНЕЦ
		               |					КОНЕЦ
		               |					И ВЫБОР
		               |						КОГДА &Подразделение ЕСТЬ NULL 
		               |							ТОГДА ИСТИНА
		               |						ИНАЧЕ Подразделение В (&Подразделение)
		               |					КОНЕЦ) КАК БюджетныйОстаткиИОбороты
		               |		ПО БюджетныйДвиженияССубконто.Регистратор = БюджетныйОстаткиИОбороты.Регистратор
		               |			И БюджетныйДвиженияССубконто.НомерСтроки = БюджетныйОстаткиИОбороты.НомерСтроки
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Период,
		               |	НомерСтроки";
	Иначе	
		 		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		 		               |	КазнаДвиженияССубконто.Период КАК Период,
		 		               |	КазнаДвиженияССубконто.СчетДт,
		 		               |	КазнаДвиженияССубконто.СчетКт,
		 		               |	КазнаДвиженияССубконто.СубконтоДт1,
		 		               |	КазнаДвиженияССубконто.СубконтоДт2,
		 		               |	КазнаДвиженияССубконто.СубконтоКт1,
		 		               |	КазнаДвиженияССубконто.СубконтоКт2,
		 		               |	КазнаДвиженияССубконто.Сумма,
		 		               |	КазнаДвиженияССубконто.Содержание,
		 		               |	КазнаДвиженияССубконто.Регистратор,
		 		               |	КазнаДвиженияССубконто.НомерСтроки КАК НомерСтроки,
		 		               |	ЕСТЬNULL(КазнаОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокДт, 0) КАК СуммаКонечныйОстатокДт,
		 		               |	ЕСТЬNULL(КазнаОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокКт, 0) КАК СуммаКонечныйОстатокКт,
		 		               |	ЕСТЬNULL(КазнаОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокДт, 0) КАК СуммаНачальныйОстатокДт,
		 		               |	ЕСТЬNULL(КазнаОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокКт, 0) КАК СуммаНачальныйОстатокКт
		 		               |ИЗ
		 		               |	РегистрБухгалтерии.Казна.ДвиженияССубконто(
		 		               |			&Дата1,
		 		               |			&Дата2,
		 		               |			(Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Казна.Кассы))
		 		               |				ИЛИ Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Казна.КорреспондентскиеСчета)))
		 		               |				И НЕ(СчетДт В (ЗНАЧЕНИЕ(ПланСчетов.Казна.ТекущиеСчета))
		 		               |						ИЛИ СчетКт В (ЗНАЧЕНИЕ(ПланСчетов.Казна.ТекущиеСчета))),
		 		               |			,
		 		               |			) КАК КазнаДвиженияССубконто
		 		               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Казна.ОстаткиИОбороты(
		 		               |				&Дата1,
		 		               |				&Дата2,
		 		               |				Запись,
		 		               |				,
		 		               |				Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Казна.Кассы))
		 		               |					ИЛИ Счет В ИЕРАРХИИ (ЗНАЧЕНИЕ(ПланСчетов.Казна.КорреспондентскиеСчета)),
		 		               |				,
		 		               |				ВЫБОР
		 		               |						КОГДА &Субконто1 ЕСТЬ NULL 
		 		               |							ТОГДА ИСТИНА
		 		               |						ИНАЧЕ ВЫБОР
		 		               |								КОГДА &ПустоеСубконто1
		 		               |									ТОГДА Субконто1 В (&Субконто1)
		 		               |								ИНАЧЕ Субконто1 В ИЕРАРХИИ (&Субконто1)
		 		               |							КОНЕЦ
		 		               |					КОНЕЦ
		 		               |					И ВЫБОР
		 		               |						КОГДА &Субконто2 ЕСТЬ NULL 
		 		               |							ТОГДА ИСТИНА
		 		               |						ИНАЧЕ ВЫБОР
		 		               |								КОГДА &ПустоеСубконто2
		 		               |									ТОГДА Субконто2 В (&Субконто2)
		 		               |								ИНАЧЕ Субконто2 В ИЕРАРХИИ (&Субконто2)
		 		               |							КОНЕЦ
		 		               |					КОНЕЦ
		 		               |					И Предприятия В
		 		               |						(ВЫБРАТЬ
		 		               |							сабПредприятиеКазна.Значение
		 		               |						ИЗ
		 		               |							Константа.сабПредприятиеКазна КАК сабПредприятиеКазна)) КАК КазнаОстаткиИОбороты
		 		               |		ПО КазнаДвиженияССубконто.Регистратор = КазнаОстаткиИОбороты.Регистратор
		 		               |			И КазнаДвиженияССубконто.НомерСтроки = КазнаОстаткиИОбороты.НомерСтроки
		 		               |
		 		               |УПОРЯДОЧИТЬ ПО
		 		               |	Период,
		 		               |	НомерСтроки";

	КонецЕсли;
	
	
	
	
	Запрос.УстановитьПараметр("Дата1", ПараметрыОтчета.Дата1);
	Запрос.УстановитьПараметр("Дата2", ПараметрыОтчета.Дата2);
	Запрос.УстановитьПараметр("Счет", СчетИИ);
	//Запрос.УстановитьПараметр("Взаиморасчеты", ПараметрыОтчета.Взаиморасчеты);
	Запрос.УстановитьПараметр("Предприятия", ?(ПустаяСтрока(ПараметрыОтчета.Предприятие), NULL, ПараметрыОтчета.Предприятие));
	Запрос.УстановитьПараметр("Подразделение", ?(ПустаяСтрока(ПараметрыОтчета.Подразделение), NULL, ПараметрыОтчета.Подразделение));
	Запрос.УстановитьПараметр("Сценарий1Условие", ?(ПараметрыОтчета.Сценарий1.Количество() > 1, NULL, 1));
	Запрос.УстановитьПараметр("Сценарий1", ПараметрыОтчета.Сценарий1);
	Запрос.УстановитьПараметр("Субконто1", ПараметрыОтчета.Субконто1);
	Запрос.УстановитьПараметр("Субконто2", ПараметрыОтчета.Субконто2);
	Запрос.УстановитьПараметр("СчитатьПоЦФО", ПараметрыОтчета.СчитатьПоЦФО);
	Запрос.УстановитьПараметр("Регистр", Регистр1);
	Запрос.УстановитьПараметр("ПустоеСубконто1", ПустаяСтрока(ПараметрыОтчета.Субконто1) И ТИпЗнч(ПараметрыОтчета.Субконто1) = Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств"));
	Запрос.УстановитьПараметр("ПустоеСубконто2", ПустаяСтрока(ПараметрыОтчета.Субконто2) И ТИпЗнч(ПараметрыОтчета.Субконто2) = Тип("СправочникСсылка.СтатьиДвиженияДенежныхСредств"));
	
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	ОбластьШапка.Параметры.Период2 = ПредставлениеПериода(ПараметрыОтчета.Дата1, ПараметрыОтчета.Дата2);
	ОбластьШапка.Параметры.СценарийПлана = ПараметрыОтчета.Сценарий1;
	ОбластьШапка.Параметры.Предприятия = ПараметрыОтчета.Предприятие;
	ОбластьШапка.Параметры.СчетаВсе = СчетИИ;
	
	ТабДок.Вывести(ОбластьШапка);
	СуммаДтИтого = 0; СуммаКтИтого = 0;
	ВыводНачало = 0;
	Пока Выборка.Следующий() Цикл
		
		//вывод сальдо начало
		Если НЕ ВыводНачало Тогда
			ОбластьНачало.Параметры.Дата1 = ПараметрыОтчета.Дата1;
			ОбластьНачало.Параметры.Заполнить(Выборка);
			ТабДок.Вывести(ОбластьНачало);
			ВыводНачало = 1;
		КонецЕсли;
		
		ОбластьСтрока.Параметры.Заполнить(Выборка);
		ОбластьСтрока.Параметры.Расшифровка = Новый Структура("Регистратор, НомерСтроки", Выборка.Регистратор, Выборка.НомерСтроки) ;
		ОбластьСтрока.Параметры.Сальдо = Выборка.СуммаКонечныйОстатокДт + Выборка.СуммаКонечныйОстатокКт;
		ОбластьСтрока.Параметры.СуммаДт = ?(НЕ СчетИИ.НайтиПоЗначению(Выборка.СчетДт) = Неопределено, Выборка.Сумма, 0);
		ОбластьСтрока.Параметры.СуммаКт = ?(НЕ СчетИИ.НайтиПоЗначению(Выборка.СчетКт) = Неопределено, Выборка.Сумма, 0);
		
		Если Выборка.СуммаКонечныйОстатокДт Тогда
			ОбластьСтрока.Параметры.Признак = "Дт";
		ИначеЕсли Выборка.СуммаКонечныйОстатокКт Тогда
			ОбластьСтрока.Параметры.Признак = "Кт";
		Иначе
			ОбластьСтрока.Параметры.Признак = "";
		КонецЕсли;
		
		ТабДок.Вывести(ОбластьСтрока);
		СуммаДтИтого = СуммаДтИтого + ОбластьСтрока.Параметры.СуммаДт;
		СуммаКтИтого = СуммаКтИтого + ОбластьСтрока.Параметры.СуммаКт;
	КонецЦикла;
	
	
	//вывод сальдо конец
	Если Выборка.Количество() Тогда
		ОбластьИтого.Параметры.СуммаДтИтого = СуммаДтИтого;
		ОбластьИтого.Параметры.СуммаКтИтого = СуммаКтИтого;
		ТабДок.Вывести(ОбластьИтого);
		
		ОбластьКонец.Параметры.Заполнить(Выборка);
		ОбластьКонец.Параметры.Дата1 = ПараметрыОтчета.Дата2;
		ТабДок.Вывести(ОбластьКонец);
	КонецЕсли;
	
	
	//таблицу на экран
	//ТабДок.ОтображатьСетку = Ложь;
	//ТабДок.Защита = Ложь;
	//ТабДок.ТолькоПросмотр = Истина;
	//ТабДок.ОтображатьЗаголовки = Ложь;
	//ТабДок.Показать();
	//Элементы.ТабДок.Видимость = Истина;
	
	
КонецПроцедуры
