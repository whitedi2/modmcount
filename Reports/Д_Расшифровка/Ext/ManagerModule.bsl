﻿Процедура ЗаполнитьТаблицу(ТабДок, ПараметрыОтчета) Экспорт
	
	//СчетаОбхода = ПараметрыОтчета.СчетаОбхода;
	
	Т = 1;
	
	Если НЕ ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено И ПараметрыОтчета.Сценарий1.Количество() > 1 Тогда
		Сообщить("В сценарии 1 не могут присутствовать одновременно сценарии плана и факта");
		Возврат;
	КонецЕсли; 
	
	
	ПланСчетов1 = ?(Не ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено, ПланыСчетов.Учетный, ПланыСчетов.Учетный);
	Регистр1 = ?(ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено, "Бюджетный", "Учетный");
	ПланСчетовЗапрос = ?(ПараметрыОтчета.Сценарий1.НайтиПоЗначению(Справочники.СценарииПланирования.Факт) = Неопределено, "Управленческий", "Учетный");
	
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
	Запрос.Текст = "ВЫБРАТЬ
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
	               |	БюджетныйДвиженияССубконто.НомерСтроки,
	               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокДт, 0) КАК СуммаКонечныйОстатокДт,
	               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаКонечныйРазвернутыйОстатокКт, 0) КАК СуммаКонечныйОстатокКт,
	               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокДт, 0) КАК СуммаНачальныйОстатокДт,
	               |	ЕСТЬNULL(БюджетныйОстаткиИОбороты.СуммаНачальныйРазвернутыйОстатокКт, 0) КАК СуммаНачальныйОстатокКт
	               |ИЗ
	               |	РегистрБухгалтерии.Бюджетный.ДвиженияССубконто(
	               |			&Дата1,
	               |			&Дата2,
	               |			ВЫБОР
	               |					КОГДА &Предприятия ЕСТЬ NULL 
	               |						ТОГДА ИСТИНА
	               |					ИНАЧЕ Предприятия В ИЕРАРХИИ (&Предприятия)
	               |				КОНЕЦ
	               |				И ВЫБОР
	               |					КОГДА &Сценарий1Условие ЕСТЬ NULL 
	               |						ТОГДА СценарийПлана В ИЕРАРХИИ (&Сценарий1)
	               |					ИНАЧЕ СценарийПлана В (&Сценарий1)
	               |				КОНЕЦ
	               |				И (СчетДт В ИЕРАРХИИ (&Счет)
	               |						И ВЫБОР
	               |							КОГДА &Субконто1 ЕСТЬ NULL 
	               |								ТОГДА ИСТИНА
	               |							ИНАЧЕ СубконтоДт1 В ИЕРАРХИИ (&Субконто1)
	               |						КОНЕЦ
	               |						И ВЫБОР
	               |							КОГДА &Субконто2 ЕСТЬ NULL 
	               |								ТОГДА ИСТИНА
	               |							ИНАЧЕ СубконтоДт2 В ИЕРАРХИИ (&Субконто2)
	               |						КОНЕЦ
	               |					ИЛИ СчетКт В ИЕРАРХИИ (&Счет)
	               |						И ВЫБОР
	               |							КОГДА &Субконто1 ЕСТЬ NULL 
	               |								ТОГДА ИСТИНА
	               |							ИНАЧЕ СубконтоКт1 В ИЕРАРХИИ (&Субконто1)
	               |						КОНЕЦ
	               |						И ВЫБОР
	               |							КОГДА &Субконто2 ЕСТЬ NULL 
	               |								ТОГДА ИСТИНА
	               |							ИНАЧЕ СубконтоКт2 В ИЕРАРХИИ (&Субконто2)
	               |						КОНЕЦ)
	               |				И (НЕ Сумма = 0),
	               |			,
	               |			) КАК БюджетныйДвиженияССубконто
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрБухгалтерии.Бюджетный.ОстаткиИОбороты(
	               |				&Дата1,
	               |				&Дата2,
	               |				Запись,
	               |				,
	               |				Счет В ИЕРАРХИИ (&Счет),
	               |				,
	               |				ВЫБОР
	               |						КОГДА &Предприятия ЕСТЬ NULL 
	               |							ТОГДА ИСТИНА
	               |						ИНАЧЕ Предприятия В ИЕРАРХИИ (&Предприятия)
	               |					КОНЕЦ
	               |					И ВЫБОР
	               |						КОГДА &Сценарий1Условие ЕСТЬ NULL 
	               |							ТОГДА СценарийПлана В ИЕРАРХИИ (&Сценарий1)
	               |						ИНАЧЕ СценарийПлана В (&Сценарий1)
	               |					КОНЕЦ
	               |					И ВЫБОР
	               |						КОГДА &Субконто1 ЕСТЬ NULL 
	               |							ТОГДА ИСТИНА
	               |						ИНАЧЕ Субконто1 В ИЕРАРХИИ (&Субконто1)
	               |					КОНЕЦ
	               |					И ВЫБОР
	               |						КОГДА &Субконто2 ЕСТЬ NULL 
	               |							ТОГДА ИСТИНА
	               |						ИНАЧЕ Субконто2 В ИЕРАРХИИ (&Субконто2)
	               |					КОНЕЦ) КАК БюджетныйОстаткиИОбороты
	               |		ПО БюджетныйДвиженияССубконто.Регистратор = БюджетныйОстаткиИОбороты.Регистратор
	               |			И БюджетныйДвиженияССубконто.НомерСтроки = БюджетныйОстаткиИОбороты.НомерСтроки
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
	
	
			   
	Запрос.УстановитьПараметр("Дата1", ПараметрыОтчета.Дата1);
	Запрос.УстановитьПараметр("Дата2", ПараметрыОтчета.Дата2);
	Запрос.УстановитьПараметр("Счет", СчетИИ);
	Запрос.УстановитьПараметр("Предприятия", ?(ПустаяСтрока(ПараметрыОтчета.Предприятие), NULL, ПараметрыОтчета.Предприятие));
	Запрос.УстановитьПараметр("Сценарий1Условие", ?(ПараметрыОтчета.Сценарий1.Количество() > 1, NULL, 1));
	Запрос.УстановитьПараметр("Сценарий1", ПараметрыОтчета.Сценарий1);
	Запрос.УстановитьПараметр("Субконто1", ?(ПустаяСтрока(ПараметрыОтчета.Субконто1), NULL, ПараметрыОтчета.Субконто1));
	Запрос.УстановитьПараметр("Субконто2", ?(ПустаяСтрока(ПараметрыОтчета.Субконто2), NULL, ПараметрыОтчета.Субконто2));
		
	
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


Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "Форма" Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = "ОбщаяФорма.сабФормаОтчета";
	КонецЕсли;
КонецПроцедуры
