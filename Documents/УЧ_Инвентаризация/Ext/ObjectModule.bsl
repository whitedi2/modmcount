﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// регистр Учетный 
	Движения.Учетный.Записывать = Истина;
	
	//сторнируем остатки
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	УЧ_ИнвентаризацияТовары.НомерСтроки,
	//               |	УЧ_ИнвентаризацияТовары.Номенклатура,
	//               |	УЧ_ИнвентаризацияТовары.КоличествоФакт,
	//               |	УЧ_ИнвентаризацияТовары.КоличествоРеализация,
	//               |	УЧ_ИнвентаризацияТовары.Сумма,
	//               |	ВЫБОР
	//               |		КОГДА УЧ_ИнвентаризацияТовары.КоличествоФакт = 0
	//               |			ТОГДА ВЫБОР
	//               |					КОГДА УЧ_ИнвентаризацияТовары.КоличествоОтклонение = 0
	//               |						ТОГДА 0
	//               |					ИНАЧЕ УЧ_ИнвентаризацияТовары.СуммаОтклонение / УЧ_ИнвентаризацияТовары.КоличествоОтклонение
	//               |				КОНЕЦ
	//               |		ИНАЧЕ УЧ_ИнвентаризацияТовары.Сумма / УЧ_ИнвентаризацияТовары.КоличествоФакт
	//               |	КОНЕЦ КАК ЦенаФакт,
	//               |	УЧ_ИнвентаризацияТовары.СуммаФакт,
	//               |	УЧ_ИнвентаризацияТовары.Количество,
	//               |	УЧ_ИнвентаризацияТовары.КоличествоПрошлаяИнвПодснятие,
	//               |	УЧ_ИнвентаризацияТовары.СуммаПрошлаяИнвПодснятие
	//               |ПОМЕСТИТЬ ВремТЧ
	//               |ИЗ
	//               |	Документ.УЧ_Инвентаризация.Товары КАК УЧ_ИнвентаризацияТовары
	//               |ГДЕ
	//               |	УЧ_ИнвентаризацияТовары.Ссылка = &Ссылка
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	ВремТЧ.НомерСтроки КАК НомерСтрокиДок,
	//               |	ВремТЧ.Номенклатура КАК Номенклатура,
	//               |	ВремТЧ.Номенклатура.Код КАК Артикул,
	//               |	ВремТЧ.Номенклатура.Счет10 КАК ТоварСчет,
	//               |	ВремТЧ.КоличествоФакт + ВремТЧ.КоличествоРеализация - ВремТЧ.Количество КАК КоличествоКорр,
	//               |	ВремТЧ.СуммаФакт - ВремТЧ.Сумма КАК СуммаКорр,
	//               |	ВремТЧ.КоличествоПрошлаяИнвПодснятие,
	//               |	ВремТЧ.СуммаПрошлаяИнвПодснятие
	//               |ИЗ
	//               |	ВремТЧ КАК ВремТЧ";
	//
	//Запрос.УстановитьПараметр("Ссылка", Ссылка); 
	//Запрос.УстановитьПараметр("Счет10", ПланыСчетов.Учетный.Счет10()); 
	//Запрос.УстановитьПараметр("Счет41", ПланыСчетов.Учетный.Счет41()); 
	//Запрос.УстановитьПараметр("Счет43", ПланыСчетов.Учетный.Счет43()); 
	//Запрос.УстановитьПараметр("ДатаОстатков", Дата); 
	//Запрос.УстановитьПараметр("Предприятие", Предприятие);
	//Запрос.УстановитьПараметр("Подразделение", Подразделение);
	//Запрос.УстановитьПараметр("Склад", Склад);
	////Запрос.УстановитьПараметр("ГруппаНоменклатуры", ГруппаНоменклатуры);
	////Запрос.УстановитьПараметр("ТЧ", Товары.Выгрузить(,"Номенклатура, КоличествоФакт, Сумма, СуммаФакт, КоличествоОтклонение, СуммаОтклонение"));
	//
	//Если ВидОперации = Перечисления.ВидыОперацийИнвентаризация.Инвентаризация Тогда
	//	ПолнаяИнвентаризация = Истина;
	//Иначе
	//	ПолнаяИнвентаризация = Ложь;
	//КонецЕсли;
	//
	//СкладПодснятий = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад подснятий (Склады)", Истина), Предприятие);
	//СкладИнвентаризаций = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад инвентаризаций (Склады)", Истина), Предприятие);
	//СкладТорговыйЗал = Подразделение.Склад;
	//
	//Результат = Запрос.Выполнить();
	//Выборка = Результат.Выбрать();
	//
	//Пока Выборка.Следующий() Цикл
	//	
	//	Если ЗначениеЗаполнено(Выборка.КоличествоКорр) Или ЗначениеЗаполнено(Выборка.СуммаКорр) Тогда
	//		Движение = Движения.Учетный.Добавить();
	//		Движение.Период = Дата;
	//		Движение.СчетДт = Выборка.ТоварСчет;
	//		Движение.СчетКт = ?(ЗначениеЗаполнено(КорСчет), КорСчет, Выборка.ТоварСчет);
	//		//Если Не ЗначениеЗаполнено(Движение.СчетДт) Тогда
	//		//	Движение.СчетДт = Выборка.Номенклатура.Счет10;
	//		//КонецЕсли;
	//		//Если Не ЗначениеЗаполнено(Движение.СчетКт) Тогда
	//		//	Движение.СчетКт = Выборка.Номенклатура.Счет10;
	//		//КонецЕсли;
	//		Если Не ЗначениеЗаполнено(Движение.СчетДт) Или Не ЗначениеЗаполнено(Движение.СчетКт) Тогда
	//			Сообщить("Не заполнены счета Дт или Кт в строке документа " + Выборка.НомерСтрокиДок + ", артикул " + Выборка.Артикул + ", " + Выборка.Номенклатура);
	//			Отказ = Истина;
	//			//Возврат;
	//		КонецЕсли;
	//		
	//		Движение.Предприятия = Предприятие;
	//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
	//		
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, Выборка.Номенклатура);
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, ?(ЗначениеЗаполнено(Склад), Склад, СкладТорговыйЗал));
	//		
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ?(ЗначениеЗаполнено(КорСубконто1), КорСубконто1, Выборка.Номенклатура));
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, ?(ЗначениеЗаполнено(КорСубконто2), КорСубконто2, ?(ПолнаяИнвентаризация, СкладИнвентаризаций, СкладПодснятий)));
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 3, КорСубконто3);
	//		
	//		Если Движение.СчетДт.УчетПоПодразделениям Тогда
	//			Движение.ПодразделениеДт = Подразделение;			
	//		КонецЕсли;
	//		
	//		Если Движение.СчетКт.УчетПоПодразделениям Тогда
	//			Движение.ПодразделениеКт = Подразделение;			
	//		КонецЕсли;
	//		
	//		//Цена = ?(ТекСтрокаТовары.КоличествоОтклонение, ТекСтрокаТовары.СуммаОтклонение / ТекСтрокаТовары.КоличествоОтклонение, 0);
	//		Движение.КоличествоДт = Выборка.КоличествоКорр;
	//		
	//		Если Движение.СчетКт.Количественный Тогда
	//			Движение.КоличествоКт = Выборка.КоличествоКорр;
	//		КонецЕсли;
	//		
	//		Движение.Сумма = Выборка.СуммаКорр;
	//		Движение.Содержание = Комментарий;
	//	КонецЕсли;
	//	
	//	Если ЗначениеЗаполнено(Выборка.КоличествоПрошлаяИнвПодснятие) Или ЗначениеЗаполнено(Выборка.СуммаПрошлаяИнвПодснятие) Тогда
	//		Движение = Движения.Учетный.Добавить();
	//		Движение.Период = Дата;
	//		Движение.СчетДт = Выборка.ТоварСчет;
	//		Движение.СчетКт = ?(ЗначениеЗаполнено(КорСчет), КорСчет, Выборка.ТоварСчет);
	//		
	//		Если Не ЗначениеЗаполнено(Движение.СчетДт) Или Не ЗначениеЗаполнено(Движение.СчетКт) Тогда
	//			Сообщить("Не заполнены счета Дт или Кт в строке документа " + Выборка.НомерСтрокиДок + ", артикул " + Выборка.Артикул + ", " + Выборка.Номенклатура);
	//			Отказ = Истина;
	//			//Возврат;
	//		КонецЕсли;
	//		
	//		Движение.Предприятия = Предприятие;
	//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
	//		
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, Выборка.Номенклатура);
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, СкладПодснятий);
	//		
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, Выборка.Номенклатура);
	//		УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, СкладИнвентаризаций);
	//		
	//		Если Движение.СчетДт.УчетПоПодразделениям Тогда
	//			Движение.ПодразделениеДт = Подразделение;			
	//		КонецЕсли;
	//		
	//		Если Движение.СчетКт.УчетПоПодразделениям Тогда
	//			Движение.ПодразделениеКт = Подразделение;			
	//		КонецЕсли;
	//		
	//		Движение.КоличествоДт = - Выборка.КоличествоПрошлаяИнвПодснятие;
	//		
	//		Если Движение.СчетКт.Количественный Тогда
	//			Движение.КоличествоКт = - Выборка.КоличествоПрошлаяИнвПодснятие;
	//		КонецЕсли;
	//		
	//		Движение.Сумма = - Выборка.СуммаПрошлаяИнвПодснятие;
	//		Движение.Содержание = Комментарий;
	//	КонецЕсли;
	//	
	//КонецЦикла;
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение и РучнаяКорректировка Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Движения документа %1 отредактированы вручную и не могут быть автоматически актуализированы'"), ЭтотОбъект);
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.КлючДанных = Ссылка;
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат;
	КонецЕсли;	

	СуммаДокумента = Товары.Итог("Сумма");
	
	//ОбновитьУчет(Истина);
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Функция ПолучитьДанныеУчета(ВыводитьТоварСНулевымОстатком, ТекНомГруппа = Неопределено, Отбор = Неопределено, ОбновлениеПриПроведении = Ложь, ПоСчетам = Ложь) Экспорт
	
	Если Отбор = Неопределено Тогда
		Отбор = Новый КомпоновщикНастроекКомпоновкиДанных;
		Если ПоСчетам Тогда
			СхемаКомпоновкиДанных = Документы.УЧ_Инвентаризация.ПолучитьМакет("МакетЗаполненияСоСчетом");	
		Иначе
			СхемаКомпоновкиДанных = Документы.УЧ_Инвентаризация.ПолучитьМакет("МакетЗаполнения");
		КонецЕсли;
		URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
		
		ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
		
		Отбор.Инициализировать(ИсточникНастроек);
		
		Отбор.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		
		Отбор.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	КонецЕсли;	
	
	//тз ВТ_Учет - таблица равна автозаполненной табличной части Товары, с применением доп. отборов, но включая товар с нувыми остатками
	Если ПоСчетам Тогда
		СхемаКомпоновкиДанных = Документы.УЧ_Инвентаризация.ПолучитьМакет("МакетЗаполненияСоСчетом");	
	Иначе
		СхемаКомпоновкиДанных = Документы.УЧ_Инвентаризация.ПолучитьМакет("МакетЗаполнения");
	КонецЕсли;
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "Период", ?(ЗначениеЗаполнено(Ссылка), МоментВремени(), Дата));
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "Предприятие", Предприятие);	
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "Организация", Организация);	
	//УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "Подразделение", Подразделение);	
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "Склад", Склад);
	//УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "СкладПодснятий", Неопределено);
	//УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "СкладОтветственногоХранения", Неопределено);
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "ВидОперации", ВидОперации);
	//Если НЕ ТекНомГруппа = "Все группы" Тогда
		УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "ГруппаНоменклатуры", ?(ЗначениеЗаполнено(ТекНомГруппа), ТекНомГруппа,ГруппаНоменклатуры));
	//Иначе
	//	УстановитьИспользованиеНастроек(Отбор.Настройки, "ГруппаНоменклатуры", Ложь);
	//КонецЕсли;
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "ВыводитьТоварСНулевымОстатком", ВыводитьТоварСНулевымОстатком);
	
	Если ОбновлениеПриПроведении Тогда
		СчетаУчета = ПолучитьСчетаНоменклатур();
		СписокНоменклатур = Товары.ВыгрузитьКолонку("Номенклатура");
		НеОтбиратьПоНоменклатуре = Ложь;
	Иначе
		СчетаУчета = Новый Массив;
		СчетаУчета.Добавить(ПланыСчетов.Учетный.Счет41());
		СчетаУчета.Добавить(ПланыСчетов.Учетный.Счет43());
		СчетаУчета.Добавить(ПланыСчетов.Учетный.Счет10());
		
		СчетаУчетаБУ = Новый Массив;
		СчетаУчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("41"));
		СчетаУчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("43"));
		СчетаУчетаБУ.Добавить(ПланыСчетов.Хозрасчетный.НайтиПоКоду("10"));

		СписокНоменклатур = Неопределено;
		НеОтбиратьПоНоменклатуре = Истина;
	КонецЕсли;
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "СчетаУчета", СчетаУчета);
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "СчетаУчетаБУ", СчетаУчетаБУ);
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "СписокНоменклатур", СписокНоменклатур);
	УстановитьЗначениеПараметраНастроек(Отбор.Настройки, "НеОтбиратьПоНоменклатуре", НеОтбиратьПоНоменклатуре);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Отбор.ПолучитьНастройки(),,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТЗ_Учет = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат ТЗ_Учет;
	
КонецФункции

Процедура ОбновитьУчет(ОбновлениеПриПроведении)
	
	Если КорСчет = ПланыСчетов.Учетный.Счет00() Тогда
		Возврат;
	КонецЕсли;
	
	ВидОперацииИнвентаризация = Перечисления.ВидыОперацийИнвентаризация.Инвентаризация; 
	
	ТЗ_Учет = ПолучитьДанныеУчета(Истина,,,ОбновлениеПриПроведении);
	Для Каждого ТекСтрокаУчет Из Товары Цикл
		НайденныеСтроки = ТЗ_Учет.НайтиСтроки(новый Структура("Номенклатура", ТекСтрокаУчет.Номенклатура));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденнаяСтрока = НайденныеСтроки[0];
			ЗаполнитьЗначенияСвойств(ТекСтрокаУчет, НайденнаяСтрока);
			//ТекСтрокаУчет.Количество = НайденнаяСтрока.Количество;
			//ТекСтрокаУчет.Сумма 	   = НайденнаяСтрока.Сумма;
			//ТекСтрокаУчет.ЦенаЗакупочная = НайденнаяСтрока.ЦенаЗакупочная;
			ТекСтрокаУчет.КоличествоПрошлаяИнвПодснятие = ?(ВидОперации = ВидОперацииИнвентаризация, НайденнаяСтрока.КоличествоПрошлаяИнвПодснятие, 0);
			ТекСтрокаУчет.СуммаПрошлаяИнвПодснятие = ?(ВидОперации = ВидОперацииИнвентаризация, НайденнаяСтрока.СуммаПрошлаяИнвПодснятие, 0);
		Иначе
			ТекСтрокаУчет.Количество = 0;
			ТекСтрокаУчет.Сумма 	   = 0;
			ТекСтрокаУчет.ЦенаЗакупочная = 0;
			ТекСтрокаУчет.КоличествоПрошлаяИнвПодснятие = 0;
			ТекСтрокаУчет.СуммаПрошлаяИнвПодснятие = 0;
		КонецЕсли;
	КонецЦикла;
	
	ПересчитатьСуммыТоваров();
	
КонецПроцедуры

Процедура ПересчитатьСуммыТоваров()
	
	Для Каждого ТекСтрока Из Товары Цикл
		
		ЦенаУчет = ?(ТекСтрока.Количество <> 0, ТекСтрока.Сумма / ТекСтрока.Количество, ТекСтрока.ЦенаЗакупочная);
		ТекСтрока.СуммаФакт = (ТекСтрока.КоличествоФакт + ТекСтрока.КоличествоРеализация) * ЦенаУчет;
		
		ТекСтрока.КоличествоОтклонение = (ТекСтрока.КоличествоФакт + ТекСтрока.КоличествоРеализация) - ТекСтрока.Количество - ТекСтрока.КоличествоПрошлаяИнвПодснятие;
		ТекСтрока.СуммаОтклонение 	   = ТекСтрока.СуммаФакт - ТекСтрока.Сумма - ТекСтрока.СуммаПрошлаяИнвПодснятие;
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЗначениеПараметраНастроек(Настройки, ИмяПараметра, Значение)
	
	Параметр = Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Значение;
		Параметр.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьИспользованиеНастроек(Настройки, ИмяПараметра, Значение)
	
	Параметр = Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Если Параметр <> Неопределено Тогда
		//Параметр.Значение = Значение;
		Параметр.Использование = Значение;
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьСчетаНоменклатур()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТЧДокумента.Товар
	|ПОМЕСТИТЬ ВТ_ТЧДокумента
	|ИЗ
	|	&ТЧДокумента КАК ТЧДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТЧДокумента.Товар,
	|	Номенклатура.Счет10 КАК ТоварСчет10
	|ПОМЕСТИТЬ ВТ_ТЧДокументаСоСчетами
	|ИЗ
	|	ВТ_ТЧДокумента КАК ВТ_ТЧДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|		ПО ВТ_ТЧДокумента.Товар = Номенклатура.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТЧДокументаСоСчетами.Товар КАК Номенклатура,
	|	ВЫБОР
	|		КОГДА ВТ_ТЧДокументаСоСчетами.ТоварСчет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	|			ТОГДА &СчетПоУмолчанию
	|		ИНАЧЕ ВТ_ТЧДокументаСоСчетами.ТоварСчет10
	|	КОНЕЦ КАК Счет
	|ИЗ
	|	ВТ_ТЧДокументаСоСчетами КАК ВТ_ТЧДокументаСоСчетами
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_ТЧДокументаСоСчетами.Товар,
	|	ВЫБОР
	|		КОГДА ВТ_ТЧДокументаСоСчетами.ТоварСчет10 = ЗНАЧЕНИЕ(ПланСчетов.Учетный.ПустаяСсылка)
	|			ТОГДА &СчетПоУмолчанию
	|		ИНАЧЕ ВТ_ТЧДокументаСоСчетами.ТоварСчет10
	|	КОНЕЦ";
	ТЧДокумента = Новый ТаблицаЗначений;
	ТЧДокумента.Колонки.Добавить("Товар", Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Для Каждого СтрокаТЧ Из Товары Цикл
		СтрокаТЧДокумента = ТЧДокумента.Добавить();
		СтрокаТЧДокумента.Товар = СтрокаТЧ.Номенклатура;
	КонецЦикла;	
	
	Запрос.УстановитьПараметр("ТЧДокумента", ТЧДокумента);
	Запрос.УстановитьПараметр("СчетПоУмолчанию", ПланыСчетов.Учетный.Счет1001());
	
	Результат = Запрос.Выполнить();
	ТЗ = Результат.Выгрузить();
	ТЗ.Свернуть("Счет");
	
	СписокСчетов = Новый СписокЗначений;
	Для Каждого СтрокаТЗ Из ТЗ Цикл;
		СписокСчетов.Добавить(СтрокаТЗ.Счет);	
	КонецЦикла;	
	
	Возврат СписокСчетов;	
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	//Если ВидОперации = Перечисления.ВидыОперацийИнвентаризация.Инвентаризация Тогда
	//	РеквизитСклад = ПроверяемыеРеквизиты.Найти("Склад");
	//	ПроверяемыеРеквизиты.Удалить(РеквизитСклад);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПодчиненныеДокументы()
	
	//Установим, нужно ли это делать
	//НеобходимоОбновитьПодчДоки = Ложь;
	//Для Каждого ТекСтрокаДопРекв Из ДополнительныеРеквизиты Цикл
	//	Если ТекСтрокаДопРекв.Свойство.Заголовок = "Создавать подчиненные документы" и ТекСтрокаДопРекв.Значение = Истина Тогда
	//		НеобходимоОбновитьПодчДоки = Истина;
	//	КонецЕсли;
	//КонецЦикла;
	//
	//Если НеобходимоОбновитьПодчДоки = Ложь Тогда Возврат; КонецЕсли;
	
	Возврат;
	
	//ДополнительныеСвойства
	
	//списание
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	УЧ_СписаниеТоваров.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.УЧ_СписаниеТоваров КАК УЧ_СписаниеТоваров
	|ГДЕ
	|	НЕ УЧ_СписаниеТоваров.ПометкаУдаления
	|	И УЧ_СписаниеТоваров.ДокОснование = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДокОбъектСписание = Выборка.Ссылка.ПолучитьОбъект();
	Иначе
		ДокОбъектСписание = Документы.УЧ_СписаниеТоваров.СоздатьДокумент();
	КонецЕсли;
	
	ДанныеЗаполнения = ЭтотОбъект;
	
	ЗаполнитьЗначенияСвойств(ДокОбъектСписание, ДанныеЗаполнения, ,"Дата, Номер, Комментарий");
	ДокОбъектСписание.Дата = ДанныеЗаполнения.Дата + 2;
	ДокОбъектСписание.ДокОснование = ДанныеЗаполнения.Ссылка;
	ДокОбъектСписание.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад инвентаризаций (Склады)", Истина), ДанныеЗаполнения.Подразделение.Владелец);
	ДокОбъектСписание.ВидДеятельности = ДанныеЗаполнения.Подразделение;
	ДокОбъектСписание.Организация = ?(ЗначениеЗаполнено(ДанныеЗаполнения.Организация), ДанныеЗаполнения.Организация, ДокОбъектСписание.ВидДеятельности.Организация);
	ДокОбъектСписание.ВидОперации = Перечисления.ВидыОперацийСписания.СписаниеПодснятий;
	ДокОбъектСписание.ТабличнаяЧасть.Очистить();
	Для Каждого СтрокаТЧ Из ДанныеЗаполнения.Товары Цикл
		
		//Если НЕ СтрокаТЧ.Номенклатура.АлкогольнаяПродукция Тогда //д1 только алко
		//	Продолжить;			
		//КонецЕсли;
		
		Если СтрокаТЧ.КоличествоОтклонение < 0 Или (СтрокаТЧ.КоличествоОтклонение = 0 И СтрокаТЧ.СуммаОтклонение < 0)Тогда
			СтрокаТЧСписания = ДокОбъектСписание.ТабличнаяЧасть.Добавить();
			СтрокаТЧСписания.Товар = СтрокаТЧ.Номенклатура;
			СтрокаТЧСписания.Количество = - СтрокаТЧ.КоличествоОтклонение;
			СтрокаТЧСписания.Сумма = - СтрокаТЧ.СуммаОтклонение;
			СтрокаТЧСписания.Цена = ?(СтрокаТЧ.КоличествоОтклонение = 0, 0, СтрокаТЧ.СуммаОтклонение/СтрокаТЧ.КоличествоОтклонение);
		КонецЕсли;
	КонецЦикла;	
	
	Если ДокОбъектСписание.ТабличнаяЧасть.Количество() > 0 Или ЗначениеЗаполнено(ДокОбъектСписание.Ссылка) Тогда
		ДокОбъектСписание.Записать(ДополнительныеСвойства.РежимЗаписи);
	КонецЕсли;
	
	//оприходование
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	УЧ_ОприходованиеТоваров.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.УЧ_ОприходованиеТоваров КАК УЧ_ОприходованиеТоваров
	|ГДЕ
	|	НЕ УЧ_ОприходованиеТоваров.ПометкаУдаления
	|	И УЧ_ОприходованиеТоваров.ДокОснование = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДокОбъектОприходование = Выборка.Ссылка.ПолучитьОбъект();
	Иначе
		ДокОбъектОприходование = Документы.УЧ_ОприходованиеТоваров.СоздатьДокумент();
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ДокОбъектОприходование, ДанныеЗаполнения, ,"Дата, Номер, Комментарий");
	ДокОбъектОприходование.Дата = ДанныеЗаполнения.Дата + 4;
	ДокОбъектОприходование.ДокОснование = ДанныеЗаполнения.Ссылка;
	ДокОбъектОприходование.Склад = сабОперОбщегоНазначения.ПолучитьСкладПоДопСвойству(ПланыВидовХарактеристик.ДополнительныеРеквизитыИСведения.НайтиПоНаименованию("Склад инвентаризаций (Склады)", Истина), ДанныеЗаполнения.Подразделение.Владелец);
	ДокОбъектОприходование.Подразделение = ДанныеЗаполнения.Подразделение;
	ДокОбъектОприходование.Организация = ДанныеЗаполнения.Организация;
	ДокОбъектОприходование.ТабличнаяЧасть.Очистить();
	Для Каждого СтрокаТЧ Из ДанныеЗаполнения.Товары Цикл
		
		//Если НЕ СтрокаТЧ.Номенклатура.АлкогольнаяПродукция Тогда //д1 только алко
		//	Продолжить;			
		//КонецЕсли;
		
		Если СтрокаТЧ.КоличествоОтклонение > 0 Или (СтрокаТЧ.КоличествоОтклонение = 0 И СтрокаТЧ.СуммаОтклонение > 0) Тогда
			СтрокаТЧСписания = ДокОбъектОприходование.ТабличнаяЧасть.Добавить();
			СтрокаТЧСписания.Товар = СтрокаТЧ.Номенклатура;
			СтрокаТЧСписания.Количество = СтрокаТЧ.КоличествоОтклонение;
			СтрокаТЧСписания.Сумма = СтрокаТЧ.СуммаОтклонение;
			СтрокаТЧСписания.Цена = ?(СтрокаТЧ.КоличествоОтклонение = 0, 0, СтрокаТЧ.СуммаОтклонение/СтрокаТЧ.КоличествоОтклонение);
		КонецЕсли;
	КонецЦикла;	
	
	Если ДокОбъектОприходование.ТабличнаяЧасть.Количество() > 0 Или ЗначениеЗаполнено(ДокОбъектОприходование.Ссылка) Тогда
		ДокОбъектОприходование.Записать(ДополнительныеСвойства.РежимЗаписи);
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ОбновитьПодчиненныеДокументы();
	
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	РучнаяКорректировка = Ложь;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
КонецПроцедуры






