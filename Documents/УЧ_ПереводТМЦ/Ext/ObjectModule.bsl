﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
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

	Если ДополнительныеСвойства.Свойство("ДатаДокументаИзменена") Тогда
		Движения.Учетный.Записать();	
	КонецЕсли;	
	
	СтруктураИмен = УЧ_Сервер.СформироватьСтруктуруИмен(ЭтотОбъект);
	СтруктараИменНовая = СтруктураИменНовая();
	
	СтруктураСоответствий = УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктураИмен);
	СтруктураСоответствийНовая =  УЧ_Сервер.ПоучитьСоответствияСчетовНоменклатуры(ЭтотОбъект, СтруктараИменНовая);
	СоответствиеСчетаНовый = СтруктураСоответствийНовая.Соответствия;
	СоответствиеУчетаПоПодразделениямНовый = СтруктураСоответствийНовая.СоответствияУчетаПодразделений;
	СоответствиеСчета = СтруктураСоответствий.Соответствия;
	СоответствиеУчетаПоПодразделениям = СтруктураСоответствий.СоответствияУчетаПодразделений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура КАК Номенклатура,
		|	СУММА(УЧ_ПереводТМЦТабличнаяЧасть.Количество) КАК Количество,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие КАК Предприятие,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Склад КАК Склад,
		|	ВЫБОР
		|		КОГДА (ВЫБОР
		|				КОГДА УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
		|					ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура.Счет10
		|				ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ
		|			КОНЕЦ).УчетПоПодразделениям
		|			ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Подразделение
		|		ИНАЧЕ NULL
		|	КОНЕЦ КАК Подразделение,
		|	ВЫБОР
		|		КОГДА (ВЫБОР
		|				КОГДА УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
		|					ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура.Счет10
		|				ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ
		|			КОНЕЦ).УчетПоПодразделениям
		|			ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.ПодразделениеПолучатель
		|		ИНАЧЕ NULL
		|	КОНЕЦ КАК ПодразделениеПолучатель,
		|	СУММА(УЧ_ПереводТМЦТабличнаяЧасть.Сумма) КАК СуммаПолучатель,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.СкладПолучатель КАК СкладПолучатель,
		|	УЧ_ПереводТМЦТабличнаяЧасть.НоменклатураНовая КАК НоменклатураНовая,
		|	СУММА(УЧ_ПереводТМЦТабличнаяЧасть.КоличествоНовое) КАК КоличествоНовое,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура.Счет10 КАК ТоварСчет10,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие.НеКонтролировать10 КАК ПредприятиеНеКонтролировать10,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие.НеКонтролировать41 КАК ПредприятиеНеКонтролировать41,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие.НеКонтролировать43 КАК ПредприятиеНеКонтролировать43
		|ПОМЕСТИТЬ ТЧДока
		|ИЗ
		|	Документ.УЧ_ПереводТМЦ.ТабличнаяЧасть КАК УЧ_ПереводТМЦТабличнаяЧасть
		|ГДЕ
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Склад,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.СкладПолучатель,
		|	УЧ_ПереводТМЦТабличнаяЧасть.НоменклатураНовая,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура.Счет10,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие.НеКонтролировать10,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие.НеКонтролировать41,
		|	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Предприятие.НеКонтролировать43,
		|	ВЫБОР
		|		КОГДА (ВЫБОР
		|				КОГДА УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
		|					ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура.Счет10
		|				ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ
		|			КОНЕЦ).УчетПоПодразделениям
		|			ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.Подразделение
		|		ИНАЧЕ NULL
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА (ВЫБОР
		|				КОГДА УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
		|					ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура.Счет10
		|				ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ
		|			КОНЕЦ).УчетПоПодразделениям
		|			ТОГДА УЧ_ПереводТМЦТабличнаяЧасть.Ссылка.ПодразделениеПолучатель
		|		ИНАЧЕ NULL
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	УчетныйОстатки.Субконто1 КАК Номенклатура,
		|	УчетныйОстатки.Субконто2 КАК Склад,
		|	ЕСТЬNULL(УчетныйОстатки.СуммаОстаток, 0) КАК Сумма,
		|	ЕСТЬNULL(УчетныйОстатки.КоличествоОстаток, 0) КАК Количество,
		|	ВЫБОР
		|		КОГДА УчетныйОстатки.КоличествоОстаток = 0
		|			ТОГДА 0
		|		ИНАЧЕ УчетныйОстатки.СуммаОстаток / УчетныйОстатки.КоличествоОстаток
		|	КОНЕЦ КАК Цена,
		|	УчетныйОстатки.Счет КАК Счет,
		|	УчетныйОстатки.Предприятия КАК Предприятия,
		|	УчетныйОстатки.Подразделение КАК Подразделение
		|ПОМЕСТИТЬ Остатки
		|ИЗ
		|	РегистрБухгалтерии.Учетный.Остатки(
		|			&ПозицияДокумента,
		|			Счет В (&Счета),
		|			,
		|			Предприятия В (&Предприятия)
		|				И Субконто1 В (&Субконто1)
		|				И Субконто2 В (&Субконто2)) КАК УчетныйОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЧДока.Номенклатура КАК Номенклатура,
		|	ЕСТЬNULL(Остатки.Количество, 0) - ТЧДока.Количество КАК КоличествоМинус,
		|	ТЧДока.Предприятие КАК Предприятие,
		|	ТЧДока.Подразделение КАК Подразделение,
		|	ТЧДока.Предприятие.УчетПоПодразделениям КАК УчетПоПодразделениям,
		|	ТЧДока.Склад КАК Склад,
		|	ТЧДока.Количество КАК КоличествоНужно,
		|	ЕСТЬNULL(Остатки.Количество, 0) КАК КоличествоОстаток,
		|	ТЧДока.ПредприятиеНеКонтролировать10 КАК ПредприятиеНеКонтролировать10,
		|	ТЧДока.ПредприятиеНеКонтролировать41 КАК ПредприятиеНеКонтролировать41,
		|	ТЧДока.ПредприятиеНеКонтролировать43 КАК ПредприятиеНеКонтролировать43,
		|	ТЧДока.ТоварСчет10 КАК ТоварСчет10
		|ПОМЕСТИТЬ КонтрольОстатков
		|ИЗ
		|	ТЧДока КАК ТЧДока
		|		ЛЕВОЕ СОЕДИНЕНИЕ Остатки КАК Остатки
		|		ПО ТЧДока.Номенклатура = Остатки.Номенклатура
		|			И ТЧДока.Предприятие = Остатки.Предприятия
		|			И ТЧДока.Склад = Остатки.Склад
		|			И (ВЫБОР
		|				КОГДА Остатки.Подразделение ЕСТЬ NULL
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ТЧДока.Подразделение = Остатки.Подразделение
		|			КОНЕЦ)
		|ГДЕ
		|	ЕСТЬNULL(Остатки.Количество, 0) - ТЧДока.Количество < 0
		|	И (ТЧДока.ТоварСчет10 ЕСТЬ NULL
		|			ИЛИ (ТЧДока.ТоварСчет10 В ИЕРАРХИИ (&Счет41)
		|					И ТЧДока.ПредприятиеНеКонтролировать41 = ЛОЖЬ
		|				ИЛИ ТЧДока.ТоварСчет10 В ИЕРАРХИИ (&Счет10)
		|					И ТЧДока.ПредприятиеНеКонтролировать10 = ЛОЖЬ
		|				ИЛИ ТЧДока.ТоварСчет10 В ИЕРАРХИИ (&Счет43)
		|					И ТЧДока.ПредприятиеНеКонтролировать43 = ЛОЖЬ))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(ТЧДока.Номенклатура) КАК Номенклатура,
		|	СУММА(ТЧДока.Количество) КАК Количество,
		|	ТЧДока.Предприятие КАК Предприятие,
		|	ТЧДока.Склад КАК Склад,
		|	ТЧДока.Подразделение КАК Подразделение,
		|	ТЧДока.ПодразделениеПолучатель КАК ПодразделениеПолучатель,
		|	СУММА(ТЧДока.СуммаПолучатель) КАК СуммаПолучатель,
		|	ТЧДока.СкладПолучатель КАК СкладПолучатель,
		|	ТЧДока.НоменклатураНовая КАК НоменклатураНовая,
		|	СУММА(ТЧДока.КоличествоНовое) КАК КоличествоНовое
		|ПОМЕСТИТЬ ТЧДокаСверн
		|ИЗ
		|	ТЧДока КАК ТЧДока
		|
		|СГРУППИРОВАТЬ ПО
		|	ТЧДока.Предприятие,
		|	ТЧДока.Склад,
		|	ТЧДока.Подразделение,
		|	ТЧДока.ПодразделениеПолучатель,
		|	ТЧДока.СкладПолучатель,
		|	ТЧДока.НоменклатураНовая
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТЧДокаСверн.Номенклатура КАК Номенклатура,
		|	ЕСТЬNULL(Остатки.Количество, 0) + ТЧДокаСверн.КоличествоНовое КАК КоличествоКонечное,
		|	ТЧДокаСверн.Предприятие КАК Предприятие,
		|	ТЧДокаСверн.Подразделение КАК Подразделение,
		|	ТЧДокаСверн.Предприятие.УчетПоПодразделениям КАК УчетПоПодразделениям,
		|	Остатки.Склад КАК Склад,
		|	ТЧДокаСверн.Количество КАК КоличествоНужно,
		|	ЕСТЬNULL(Остатки.Количество, 0) КАК КоличествоОстаток,
		|	ЕСТЬNULL(Остатки.Сумма, 0) КАК СуммаКонечное,
		|	ТЧДокаСверн.СкладПолучатель КАК СкладПолучатель,
		|	ТЧДокаСверн.ПодразделениеПолучатель КАК ПодразделениеПолучатель,
		|	ТЧДокаСверн.НоменклатураНовая КАК НоменклатураНовая,
		|	ТЧДокаСверн.КоличествоНовое КАК КоличествоНовое
		|ИЗ
		|	ТЧДокаСверн КАК ТЧДокаСверн
		|		ЛЕВОЕ СОЕДИНЕНИЕ Остатки КАК Остатки
		|		ПО ТЧДокаСверн.НоменклатураНовая = Остатки.Номенклатура
		|			И ТЧДокаСверн.Предприятие = Остатки.Предприятия
		|			И ТЧДокаСверн.СкладПолучатель = Остатки.Склад
		|			И (ВЫБОР
		|				КОГДА Остатки.Подразделение ЕСТЬ NULL
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ ТЧДокаСверн.Подразделение = Остатки.Подразделение
		|			КОНЕЦ)
		|ГДЕ
		|	ЕСТЬNULL(Остатки.Количество, 0) < 0";
		
	ВыбСчет = Новый Массив;
	ВыбТовары = Новый Массив;
	Для каждого ТекСтрока Из СоответствиеСчета Цикл
		Если ЗначениеЗаполнено(ТекСтрока.Ключ) Тогда
			ВыбТовары.Добавить(ТекСтрока.Ключ);
			Если ВыбСчет.Найти(ТекСтрока.Значение) = Неопределено Тогда
				ВыбСчет.Добавить(ТекСтрока.Значение);
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	
	ВыбСклад = Новый Массив;
	ВыбСклад.Добавить(Склад);
	ВыбСклад.Добавить(СкладПолучатель);
	
	ВыбПодразделение = Новый Массив;
	ВыбПодразделение.Добавить(Подразделение);
	//ВыбПодразделение.Добавить(ПодразделениеПолучатель);
	
	МоментКонца = МоментВремени();
	
	Запрос.УстановитьПараметр("Счета", ВыбСчет);
	Запрос.УстановитьПараметр("Субконто1", ВыбТовары);
	Запрос.УстановитьПараметр("Субконто2", ВыбСклад);
	Запрос.УстановитьПараметр("Подразделения", ВыбПодразделение);
	Запрос.УстановитьПараметр("Предприятия", Предприятие);
	Запрос.УстановитьПараметр("ПозицияДокумента", МоментКонца);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Счет10", ПланыСчетов.Учетный.Счет10());
	Запрос.УстановитьПараметр("Счет41", ПланыСчетов.Учетный.Счет41());
	Запрос.УстановитьПараметр("Счет43", ПланыСчетов.Учетный.Счет43());
	
	МассивЗапросов = Запрос.ВыполнитьПакетСПромежуточнымиДанными();
	
	РезультатОстатки = МассивЗапросов[1].Выгрузить();
	РезультатКонтроль = МассивЗапросов[2].Выгрузить();
	РезультатКонтрольМинусов = МассивЗапросов[4].Выгрузить();
	
	//Если АвтоПереводНоменклатуры Тогда
	//	Для Каждого СтрокаРеал Из ТабличнаяЧасть Цикл
	//		Если СтрокаРеал.Номенклатура.ПризнакНоменклатуры = "Перевод в №2" И ЗначениеЗаполнено(СтрокаРеал.Номенклатура.НоменклатураПервичная) Тогда
	//			ВыбТовары.Добавить(СтрокаРеал.Номенклатура.НоменклатураПервичная);	
	//		КонецЕсли;
	//	КонецЦикла;	
	//КонецЕсли;
	
	Движения.Учетный.Записывать = Истина;
	
	
	ТЧ2 = ТабличнаяЧасть.Выгрузить();
	
	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
		Если АвтоПереводНоменклатуры И ТекСтрокаТабличнаяЧасть.Номенклатура.ПризнакНоменклатуры = "Перевод в №2" И ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Номенклатура.НоменклатураПервичная) Тогда
			ЕстьАвтоПереводНоменклатуры = Истина;
		Иначе
			ЕстьАвтоПереводНоменклатуры = Ложь;
		КонецЕсли;		
		
		Движение = Движения.Учетный.Добавить();
		Движение.Период = Дата;
		Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
		Движение.Предприятия = Предприятие;
		Движение.СчетДт = СоответствиеСчетаНовый.Получить(ТекСтрокаТабличнаяЧасть.НоменклатураНовая);
		Если Движение.СчетДт.УчетПоПодразделениям Тогда
			Движение.ПодразделениеДт = Подразделение;
		КонецЕсли;	
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = СкладПолучатель;
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, ТекСтрокаТабличнаяЧасть.НоменклатураНовая);
		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 3, ТекСтрокаТабличнаяЧасть.СерияНоменклатурыНовая);
		Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.КоличествоНовое;
		Движение.СчетКт = СоответствиеСчета.Получить(ТекСтрокаТабличнаяЧасть.Номенклатура);
		УчетПоподразделениямСчетУчета = СоответствиеУчетаПоПодразделениям.Получить(Движение.СчетКт);
		Если УчетПоподразделениямСчетУчета Тогда
			Движение.ПодразделениеКт = Подразделение;
		КонецЕсли;
		Если Движение.СчетКт = ПланыСчетов.Учетный.Счет91() Тогда
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Статьи затрат", Истина)] = Справочники.СтатьиДоходовРасходов.НайтиПоНаименованию("Списание материалов и ГП (недостачи/излишки)", Истина);
		Иначе	
			Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Склады", Истина)] = Склад;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, ТекСтрокаТабличнаяЧасть.СерияНоменклатуры);
			Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество;
		КонецЕсли;
		
		
		Если ЕстьАвтоПереводНоменклатуры Тогда
			СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Номенклатура.НоменклатураПервичная, Склад, Движение.СчетКт);
		Иначе
			Если УчетПоподразделениямСчетУчета Тогда
				СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет, Подразделение", ТекСтрокаТабличнаяЧасть.Номенклатура, Склад, Движение.СчетКт, Подразделение);
			Иначе
				СтруктураПоиска = Новый Структура("Номенклатура, Склад, Счет", ТекСтрокаТабличнаяЧасть.Номенклатура, Склад, Движение.СчетКт);
			КонецЕсли;
		КонецЕсли;	
		
		ТекЦена = 0;
		//Если ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.Сумма) Тогда
		//	Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
		//Иначе	
			ВыборкаДетальныеЗаписи = РезультатОстатки.НайтиСтроки(СтруктураПоиска);
			Если ВыборкаДетальныеЗаписи.Количество() Тогда
				Движение.Сумма = ВыборкаДетальныеЗаписи[0].Цена * ТекСтрокаТабличнаяЧасть.Количество;
				ТекЦена = ВыборкаДетальныеЗаписи[0].Цена;
			Иначе
				Движение.Сумма = 0;
			КонецЕсли;
		//КонецЕсли;
		ТекСумма = Движение.Сумма;
		СчетДт = Движение.СчетДт;
		Движение.Содержание = Комментарий;
		
		ТекИндексСтроки = ТабличнаяЧасть.Индекс(ТекСтрокаТабличнаяЧасть);
		ТЧ2[ТекИндексСтроки].Сумма = ТекСумма;
		ТЧ2[ТекИндексСтроки].Цена = ТекЦена;
		
				
	КонецЦикла;
	
	
	СтатьяПоУмолчанию = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Списание недостач", Истина);
	СлужбаПоУмолчанию = Справочники.Субконто.НайтиПоНаименованию("Производство_общее");
	ПроизводственноеПодразделение = Подразделение.ПроизводственноеПодразделение;
	СчетЗатратыПроизводство = ПланыСчетов.Учетный.Счет25();//.ОсновноеПрво;
	СчетСебестоимость = ПланыСчетов.Учетный.Счет9002();//.Себестоимость;
	СтатьяФормальнаяСебестоимость = Справочники.СтатьиЗатрат.НайтиПоНаименованию("Формальная себестоимость", Истина);
	
	//контроль выхода из минуса
	ТЧ2.Свернуть("НоменклатураНовая", "КоличествоНовое, Сумма");
	МассивУжеВыведенныхИзМинуса = Новый Массив;
	Для каждого ТекСтрокаТабличнаяЧасть Из ТЧ2 Цикл
	
		СтруктураПоискаМинусов = Новый Структура("НоменклатураНовая, СкладПолучатель", ТекСтрокаТабличнаяЧасть.НоменклатураНовая, СкладПолучатель); 
		НайденныеСтрокиМинусов = РезультатКонтрольМинусов.НайтиСтроки(СтруктураПоискаМинусов);
		Для каждого ТекСтрокаМинусов Из НайденныеСтрокиМинусов Цикл
			ТекЦена = ?(ТекСтрокаТабличнаяЧасть.КоличествоНовое, ТекСтрокаТабличнаяЧасть.Сумма / ТекСтрокаТабличнаяЧасть.КоличествоНовое, 0);
			ТекСумма = ТекСтрокаТабличнаяЧасть.Сумма;
			Если НЕ Окр(ТекСтрокаМинусов.СуммаКонечное + ТекСумма - ТекЦена * ТекСтрокаМинусов.КоличествоКонечное, 2) Тогда
				Продолжить;			
			КонецЕсли;
			Если МассивУжеВыведенныхИзМинуса.Найти(ТекСтрокаМинусов.НоменклатураНовая) = Неопределено Тогда
				МассивУжеВыведенныхИзМинуса.Добавить(ТекСтрокаМинусов.НоменклатураНовая);
			Иначе
				Продолжить;
			КонецЕсли;
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.Предприятия = Предприятие;
			//вставка на выбор счета (обр №00000000687 Сети)
			Если ПроизводственноеПодразделение Тогда
				Движение.СчетДт = СчетЗатратыПроизводство;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,СтатьяПоУмолчанию);
				Если Движение.СчетДт.ВидыСубконто.Количество() >= 2 Тогда
					УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,СлужбаПоУмолчанию);
				КонецЕсли;
			Иначе	
				Движение.СчетДт = СчетСебестоимость;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаМинусов.Номенклатура);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,СтатьяФормальнаяСебестоимость);
			КонецЕсли;	
			//конец вставки
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = Подразделение;
			КонецЕсли;
			Движение.СчетКт = СоответствиеСчета.Получить(ТекСтрокаМинусов.НоменклатураНовая);
			Если Движение.СчетКт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеКт = Подразделение;
			КонецЕсли;	
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаМинусов.НоменклатураНовая);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,СкладПолучатель);
			//УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,3,ТекСтрокаМинусов.СерияНоменклатурыНовая);
			
			Движение.Сумма = ТекСтрокаМинусов.СуммаКонечное + ТекСумма - ТекЦена * ТекСтрокаМинусов.КоличествоКонечное;
			Движение.Содержание = "Корректировка до с/с последнего перемещения " + Формат(ТекЦена, "ЧДЦ=2") ;
		КонецЦикла;
	КонецЦикла;
	
	// Контроль лтритцательных остатков
	//УЧ_Сервер.ПроверитьОтрицательныеОстатки(Ссылка,ПланыСчетов.Учетный.Счет41(),Отказ);
	
	//контроль остатков новый
	НеКонтролироватьОстатки = сабОбщегоНазначения.ПолучитьЗначениеСвойства(ПараметрыСеанса.ТекущийПользователь, "Разрешено проведение без контроля остатков");
	Если Не НеКонтролироватьОстатки = Истина Тогда
		Для каждого ТекСтрокаМинус Из РезультатКонтроль Цикл
			Отказ = Истина;
			Сообщить(?(ТекСтрокаМинус.УчетПоПодразделениям, "По Подразделению " + Строка(ТекСтрокаМинус.Подразделение) + " ", "") + "На Складе """ + Строка(ТекСтрокаМинус.Склад) + """ номенклатуры """ + Строка(ТекСтрокаМинус.Номенклатура) + " (" + Строка(ТекСтрокаМинус.Номенклатура.Код)  + ")"" из необходимых " + Строка(ТекСтрокаМинус.КоличествоНужно) + " присутствует только "  + Строка(ТекСтрокаМинус.КоличествоОстаток) );
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	СуммаИтог = ТабличнаяЧасть.Итог("Сумма");
	СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
	
	//проверка на изменение даты
	Если ЗначениеЗаполнено(Ссылка) И НЕ Дата = Ссылка.Дата Тогда
		ДополнительныеСвойства.Вставить("ИзмененаДатаДокумента", Истина);	
	КонецЕсли;
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
		
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПеремещениеТоваров") Тогда
		ЗапросПоТаблицеПеревода = Новый Запрос;
		ЗапросПоТаблицеПеревода.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаПереводовВИнгредиентыСрезПоследних.Номенклатура,
		|	ТаблицаПереводовВИнгредиентыСрезПоследних.Ингридиент,
		|	ТаблицаПереводовВИнгредиентыСрезПоследних.КоэффициентПеревода
		|ИЗ
		|	РегистрСведений.ТаблицаПереводовВИнгредиенты.СрезПоследних(&Дата, Номенклатура В (&Номенклатуры)) КАК ТаблицаПереводовВИнгредиентыСрезПоследних";
		ЗапросПоТаблицеПеревода.УстановитьПараметр("Дата", ТекущаяДата());
		ЗапросПоТаблицеПеревода.УстановитьПараметр("Номенклатуры", ДанныеЗаполнения.ТабличнаяЧасть.ВыгрузитьКолонку("Номенклатура"));
		ТаблицаПереводов = ЗапросПоТаблицеПеревода.Выполнить().Выгрузить();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, ,"Номер, Дата, ВидОперации, ДокОснование");
		ЭтотОбъект.ДокОснование = ДанныеЗаполнения;
		Подразделение = ПодразделениеПолучатель;
		Склад = СкладПолучатель;
		Для Каждого СтрокаТовара Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			СтрокаПеревода = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПеревода, СтрокаТовара);
			СтрокиПереводов = ТаблицаПереводов.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТовара.Номенклатура));
			Если СтрокиПереводов.Количество() > 0 Тогда
				СтруктураПеревода = СтрокиПереводов[0];
				СтрокаПеревода.НоменклатураНовая = СтруктураПеревода.Ингридиент;
				СтрокаПеревода.КоэффициентПеревода = СтруктураПеревода.КоэффициентПеревода;
				СтрокаПеревода.НовыйСчетУчетаБУ = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(СтрокаПеревода.НоменклатураНовая);
				Если Не СтрокаПеревода.КоэффициентПеревода = 0 Тогда
					СтрокаПеревода.КоличествоНовое = СтрокаПеревода.Количество * СтрокаПеревода.КоэффициентПеревода;
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.УЧ_ПоступлениеТоваров") Тогда
		ЗапросПоТаблицеПеревода = Новый Запрос;
		ЗапросПоТаблицеПеревода.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаПереводовВИнгредиентыСрезПоследних.Номенклатура,
		|	ТаблицаПереводовВИнгредиентыСрезПоследних.Ингридиент,
		|	ТаблицаПереводовВИнгредиентыСрезПоследних.КоэффициентПеревода
		|ИЗ
		|	РегистрСведений.ТаблицаПереводовВИнгредиенты.СрезПоследних(&Дата, Номенклатура В (&Номенклатуры)) КАК ТаблицаПереводовВИнгредиентыСрезПоследних";
		ЗапросПоТаблицеПеревода.УстановитьПараметр("Дата", ТекущаяДата());
		ЗапросПоТаблицеПеревода.УстановитьПараметр("Номенклатуры", ДанныеЗаполнения.ТабличнаяЧасть.ВыгрузитьКолонку("Номенклатура"));
		ТаблицаПереводов = ЗапросПоТаблицеПеревода.Выполнить().Выгрузить();
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения, ,"Номер, Дата, ВидОперации, ДокОснование");
		ЭтотОбъект.ДокОснование = ДанныеЗаполнения;
		ПодразделениеПолучатель = Подразделение;
		СкладПолучатель = Склад;
		Для Каждого СтрокаТовара Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			СтрокаПеревода = ТабличнаяЧасть.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаПеревода, СтрокаТовара);
			СтрокиПереводов = ТаблицаПереводов.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТовара.Номенклатура));
			Если СтрокиПереводов.Количество() > 0 Тогда
				СтруктураПеревода = СтрокиПереводов[0];
				СтрокаПеревода.НоменклатураНовая = СтруктураПеревода.Ингридиент;
				СтрокаПеревода.КоэффициентПеревода = СтруктураПеревода.КоэффициентПеревода;
				СтрокаПеревода.НовыйСчетУчетаБУ = сабОбщегоНазначения.ПолучитьСчетУчетаНоменклатуры(СтрокаПеревода.НоменклатураНовая);
				Если Не СтрокаПеревода.КоэффициентПеревода = 0 Тогда
					СтрокаПеревода.КоличествоНовое = СтрокаПеревода.Количество * СтрокаПеревода.КоэффициентПеревода;
				КонецЕсли;	
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Функция ПоучитьСоответствияСчетовНоменклатуры()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура КАК Номенклатура,
	               |	ВЫБОР
	               |		КОГДА УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Учетный.Товары)
	               |		ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ
	               |	КОНЕЦ КАК Счет
	               |ПОМЕСТИТЬ ТТТ
	               |ИЗ
	               |	Документ.УЧ_ПереводТМЦ.ТабличнаяЧасть КАК УЧ_ПереводТМЦТабличнаяЧасть
	               |ГДЕ
	               |	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	УЧ_ПереводТМЦТабличнаяЧасть.Номенклатура,
	               |	ВЫБОР
	               |		КОГДА УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Учетный.Товары)
	               |		ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.СчетУчетаБУ
	               |	КОНЕЦ
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	УЧ_ПереводТМЦТабличнаяЧасть.НоменклатураНовая,
	               |	ВЫБОР
	               |		КОГДА УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Учетный.Товары)
	               |		ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ
	               |	КОНЕЦ
	               |ИЗ
	               |	Документ.УЧ_ПереводТМЦ.ТабличнаяЧасть КАК УЧ_ПереводТМЦТабличнаяЧасть
	               |ГДЕ
	               |	УЧ_ПереводТМЦТабличнаяЧасть.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	УЧ_ПереводТМЦТабличнаяЧасть.НоменклатураНовая,
	               |	ВЫБОР
	               |		КОГДА УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	               |			ТОГДА ЗНАЧЕНИЕ(ПланСчетов.Учетный.Товары)
	               |		ИНАЧЕ УЧ_ПереводТМЦТабличнаяЧасть.НовыйСчетУчетаБУ
	               |	КОНЕЦ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ТТТ.Номенклатура КАК Номенклатура,
	               |	ТТТ.Счет КАК Счет,
	               |	ТТТ.Счет.УчетПоПодразделениям КАК УчетПоПодразделениям
	               |ИЗ
	               |	ТТТ КАК ТТТ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ЭтоДокументДвиженияТМЦИОпцияВыключена = сабОбщегоНазначенияКлиентСервер.ЭтоДокументДвиженияТМЦИОпцияВыключена(Ссылка);
	
	Соответствия = Новый Соответствие;
	СоответствияУчетаПодразделений = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		Соответствия.Вставить(Выборка.Номенклатура, Выборка.Счет);
		СоответствияУчетаПодразделений.Вставить(Выборка.Счет, МИН(НЕ ЭтоДокументДвиженияТМЦИОпцияВыключена, Выборка.УчетПоПодразделениям));
	КонецЦикла;
	Соответствия.Вставить(Неопределено, ПланыСчетов.Учетный.Счет41());
	Соответствия.Вставить(Null, ПланыСчетов.Учетный.Счет41());
	Соответствия.Вставить(Справочники.Номенклатура.ПустаяСсылка(), ПланыСчетов.Учетный.Счет41());
	Возврат Новый Структура("Соответствия, СоответствияУчетаПодразделений", Соответствия, СоответствияУчетаПодразделений);	
	
КонецФункции // ()

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Если Не Подразделение.ПроизводственноеПодразделение И Константы.сабМодульОперативныйУчет.Получить() Тогда
	//	ТЧДока = Новый ТаблицаЗначений;
	//	ТЧДока.Колонки.Добавить("Номенклатура", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	//	ТЧДока.Колонки.Добавить("НоменклатураНовая", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	//	ТЧДока.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15,3)));
	//	
	//	Для Каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
	//		СтрокаТЧДока = ТЧДока.Добавить();
	//		СтрокаТЧДока.Номенклатура = СтрокаТЧ.Номенклатура;
	//		СтрокаТЧДока.НоменклатураНовая = СтрокаТЧ.НоменклатураНовая;
	//		СтрокаТЧДока.НомерСтроки = СтрокаТЧ.НомерСтроки;
	//	КонецЦикла;	
	//	
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ТЧДокумента.НомерСтроки,
	//	|	ТЧДокумента.Номенклатура,
	//	|	ТЧДокумента.НоменклатураНовая
	//	|ПОМЕСТИТЬ ВТ_ТЧДока
	//	|ИЗ
	//	|	&ТЧДокумента КАК ТЧДокумента
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ
	//	|	ВТ_ТЧДока.НомерСтроки,
	//	|	ВТ_ТЧДока.Номенклатура,
	//	|	ВТ_ТЧДока.Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	//	|	ВТ_ТЧДока.НоменклатураНовая,
	//	|	ВТ_ТЧДока.НоменклатураНовая.ТипНоменклатуры КАК ТипНовойНоменклатуры,
	//	|   Выбор когда ВТ_ТЧДока.НоменклатураНовая.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Сырье) 
	//	|		ИЛИ ВТ_ТЧДока.НоменклатураНовая.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Материалы) Тогда
	//	|		Истина
	//	|	Иначе
	//	|		Ложь
	//	|	Конец КАК НеВернаяНоваяНоменклатура	
	//	|ИЗ
	//	|	ВТ_ТЧДока КАК ВТ_ТЧДока
	//	|ГДЕ
	//	|	(ВТ_ТЧДока.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Сырье)
	//	|			ИЛИ ВТ_ТЧДока.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Материалы)
	//	|			ИЛИ ВТ_ТЧДока.НоменклатураНовая.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Сырье)
	//	|			ИЛИ ВТ_ТЧДока.НоменклатураНовая.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Материалы))";
	//	Запрос.УстановитьПараметр("ТЧДокумента", ТЧДока);
	//	
	//	РезультатЗапроса = Запрос.Выполнить();
	//	
	//	Если Не РезультатЗапроса.Пустой() Тогда
	//		Отказ = Истина;
	//		Выборка = РезультатЗапроса.Выбрать();
	//		Пока Выборка.Следующий() Цикл
	//			Сообщение = Новый СообщениеПользователю();
	//			Сообщение.Поле = "ТабличнаяЧасть[" + Строка(Выборка.НомерСтроки - 1) + ?(Выборка.НеВернаяНоваяНоменклатура, "].НоменклатураНовая", "].Номенклатура");
	//			Сообщение.Текст = "В строке " + Выборка.НомерСтроки + " выбрана номенклатура с неправильным типом: " + ?(Выборка.НеВернаяНоваяНоменклатура, Выборка.ТипНовойНоменклатуры, Выборка.ТипНоменклатуры);
	//			Сообщение.УстановитьДанные(ЭтотОбъект);
	//			Сообщение.Сообщить();
	//		КонецЦикла;
	//	КонецЕсли; 
	//КонецЕсли;	
	
КонецПроцедуры

Функция СтруктураИменНовая()
		СтруктураИмен = Новый Структура;
		СтруктураИмен.Вставить("Предприятие", "Предприятие");
		СтруктураИмен.Вставить("Подразделение", "Подразделение");
		СтруктураИмен.Вставить("Склад", "Склад");
		СтруктураИмен.Вставить("Номенклатура", "НоменклатураНовая");
	    СтруктураИмен.Вставить("Количество", "КоличествоНовое");
	    СтруктураИмен.Вставить("Товары", "ТабличнаяЧасть");
		СтруктураИмен.Вставить("Счет10", "НовыйСчетУчетаБУ");
		Возврат СтруктураИмен; 
КонецФункции

Процедура ОбработкаУдаленияПроведения(Отказ)
		РучнаяКорректировка = Ложь;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	

КонецПроцедуры
