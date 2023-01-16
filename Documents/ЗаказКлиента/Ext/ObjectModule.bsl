﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	// закомментированно 24.07.2017 загрузка EDI Астор-ФК {
	//ТЧСвернутая = ТабличнаяЧасть.Выгрузить();	
	//
	//ТЧСвернутая.Свернуть("Номенклатура, Склад, Цена, Доставка, ВидДоставки, СтавкаНДС, ВидЦеныПоставщика, ДатаПоступления, ЕдиницаИзмерения, ЦенаПодтвержденная, СтатусПодтвержденияПозиции", 
	//						"Количество, Сумма, СуммаДоставки, СуммаБезНДС, СуммаНДС, КоличествоУпаковок, КоличествоПодтвержденное");
	//						
	//Если ТЧСвернутая.Количество() <> ТабличнаяЧасть.Количество() Тогда
	//	ТабличнаяЧасть.Загрузить(ТЧСвернутая);
	//	Сообщить("В строках обнаружены дубли номенклатур, была произведена свертка дублей!");
	//КонецЕсли;	
    //} 
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СуммаДокумента = ТабличнаяЧасть.Итог("Сумма") + ?(Не ЦенаВключаетНДС, ТабличнаяЧасть.Итог("СуммаНДС"), 0);
	//СуммаДокумента = СуммаДокумента;
	
	//ДатаДоставки = ДатаПоступления;
	
	//Заказ помечен на удаление
	Если ПометкаУдаления = Истина И Ссылка.ПометкаУдаления = Ложь Тогда
		Запрос = новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	УЧ_Реализация.Ссылка КАК Ссылка
		               |ИЗ
		               |	Документ.УЧ_Реализация КАК УЧ_Реализация
		               |ГДЕ
		               |	УЧ_Реализация.ДокОснование = &ДокОснование
		               |	И НЕ УЧ_Реализация.ПометкаУдаления
		               |
		               |ОБЪЕДИНИТЬ ВСЕ
		               |
		               |ВЫБРАТЬ
		               |	РеализацияТоваровУслуг.Ссылка
		               |ИЗ
		               |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
		               |ГДЕ
		               |	НЕ РеализацияТоваровУслуг.ПометкаУдаления
		               |	И РеализацияТоваровУслуг.Заказ = &ДокОснование";
		Запрос.УстановитьПараметр("ДокОснование", Ссылка);
		РезультатЗапроса = Запрос.Выполнить();
		
		Если Не РезультатЗапроса.Пустой() Тогда
			Сообщить("Невозможно удалить заказ, поскольку есть подчиненные документы");
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	////формирование комментария
	//ПрочиеУсловия = Договор.ПрочиеУсловия;
	//Если ЗначениеЗаполнено(ПрочиеУсловия) Тогда
	//	НайденныйТекст = СтрНайти(Комментарий, " (ДопУсловия: ");
	//	Если НайденныйТекст Тогда
	//		Комментарий = Лев(Комментарий, НайденныйТекст - 1);		
	//	КонецЕсли;		
	//	Комментарий = Комментарий + " (ДопУсловия: " + ПрочиеУсловия + ")";
	//КонецЕсли;
		
	 //из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЧДокумента.КоличествоУпаковок,
	|	ТЧДокумента.Номенклатура
	|ПОМЕСТИТЬ ВТ_ТЧДока
	|ИЗ
	|	&ТЧДокумента КАК ТЧДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ТЧДока.КоличествоУпаковок,
	|	ВТ_ТЧДока.Номенклатура,
	|	ЕСТЬNULL(ВТ_ТЧДока.КоличествоУпаковок * ВТ_ТЧДока.Номенклатура.Вес, 0) КАК ВесТовара
	|ИЗ
	|	ВТ_ТЧДока КАК ВТ_ТЧДока";
	Запрос.УстановитьПараметр("ТЧДокумента", ТабличнаяЧасть.Выгрузить(, "КоличествоУпаковок, Номенклатура"));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ВесТовара = 0;
	Пока Выборка.Следующий() Цикл
		ВесТовара = ВесТовара + Выборка.ВесТовара;		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
		
	ЕстьОшибки = Ложь;
	
	РеквизитДатаПоступления = ПроверяемыеРеквизиты.Найти("ДатаПоступления");
	
	//Если Не ПоступлениеОднойДатой Тогда
	//	ПроверяемыеРеквизиты.Удалить(РеквизитДатаПоступления);
	//КонецЕсли;	
	
	Если ВидОперации = Перечисления.ВидыЗаказов.ВнутреннееПеремещение Тогда
		РеквизитЦена = ПроверяемыеРеквизиты.Найти("ТабличнаяЧасть.Цена");
		ПроверяемыеРеквизиты.Удалить(РеквизитЦена);
		РеквизитДоговор = ПроверяемыеРеквизиты.Найти("Договор");
		ПроверяемыеРеквизиты.Удалить(РеквизитДоговор);
	Иначе
		НужнаПроверкаДоговора = Справочники.сабМониторВнедрения.НайтиПоНаименованию("ПроверятьЗаполнениеДоговоровВДокументах", Истина).Значение;
		Если НЕ НужнаПроверкаДоговора = Неопределено И НужнаПроверкаДоговора Тогда
			РеквизитДоговор = ПроверяемыеРеквизиты.Найти("Договор");
			Если РеквизитДоговор = Неопределено Тогда
				ПроверяемыеРеквизиты.Добавить("Договор");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если БезвозмезднаяПередача Тогда
		РеквизитЦена = ПроверяемыеРеквизиты.Найти("ТабличнаяЧасть.Цена");
		ПроверяемыеРеквизиты.Удалить(РеквизитЦена);
	КонецЕсли;
	
	//Проверим на правильность ассортимента
	//Если ВидОперации = Перечисления.ВидыЗаказов.ЗакупкаТоваров И Не Подразделение.ПроизводственноеПодразделение И Не Контрагент.Учетный Тогда
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	КорзинаТорговТовары.Номенклатура,
	//	|	ТоргиСрезПоследних.ВыведенаИзТоргов КАК ВыведенаИзТоргов
	//	|ПОМЕСТИТЬ ВТ_Торги
	//	|ИЗ
	//	|	Справочник.КорзинаТоргов.Товары КАК КорзинаТорговТовары
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Торги.СрезПоследних(&Период, ) КАК ТоргиСрезПоследних
	//	|		ПО КорзинаТорговТовары.Ссылка = ТоргиСрезПоследних.Корзина
	//	|			И КорзинаТорговТовары.Номенклатура = ТоргиСрезПоследних.Номенклатура
	//	|;
	//	|
	//	|////////////////////////////////////////////////////////////////////////////////
	//	|ВЫБРАТЬ
	//	|	ПараметрыОбеспеченияПотребностиСрезПоследних.Номенклатура
	//	|ИЗ
	//	|	РегистрСведений.НоменклатураПоставщика.СрезПоследних(
	//	|			&Период,
	//	|			Предприятие = &Предприятие
	//	|				И Подразделение = &Подразделение) КАК НоменклатураПоставщикаСрезПоследних
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АссортиментнаяМатрица.СрезПоследних(
	//	|				&Период,
	//	|				Предприятие = &Предприятие
	//	|					И Подразделение = &Подразделение) КАК АссортиментнаяМатрицаСрезПоследних
	//	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыОбеспеченияПотребности.СрезПоследних(
	//	|					&Период,
	//	|					Предприятие = &Предприятие
	//	|						И Подразделение = &Подразделение) КАК ПараметрыОбеспеченияПотребностиСрезПоследних
	//	|			ПО АссортиментнаяМатрицаСрезПоследних.Номенклатура = ПараметрыОбеспеченияПотребностиСрезПоследних.Номенклатура
	//	|				И АссортиментнаяМатрицаСрезПоследних.Предприятие = ПараметрыОбеспеченияПотребностиСрезПоследних.Предприятие
	//	|				И АссортиментнаяМатрицаСрезПоследних.Подразделение = ПараметрыОбеспеченияПотребностиСрезПоследних.Подразделение
	//	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Торги КАК ВТ_Торги
	//	|			ПО АссортиментнаяМатрицаСрезПоследних.Номенклатура = ВТ_Торги.Номенклатура
	//	|		ПО НоменклатураПоставщикаСрезПоследних.Номенклатура = АссортиментнаяМатрицаСрезПоследних.Номенклатура
	//	|			И НоменклатураПоставщикаСрезПоследних.Подразделение = АссортиментнаяМатрицаСрезПоследних.Подразделение
	//	|			И НоменклатураПоставщикаСрезПоследних.Предприятие = АссортиментнаяМатрицаСрезПоследних.Предприятие
	//	|ГДЕ
	//	|	НЕ ПараметрыОбеспеченияПотребностиСрезПоследних.Номенклатура ЕСТЬ NULL 
	//	|	И НоменклатураПоставщикаСрезПоследних.Контрагент = &Контрагент
	//	|	И АссортиментнаяМатрицаСрезПоследних.ВыведенИзАссортимента = ЛОЖЬ
	//	|	И ЕСТЬNULL(ВТ_Торги.ВыведенаИзТоргов, ЛОЖЬ) = ЛОЖЬ";
	//	Запрос.УстановитьПараметр("Период", Дата);
	//	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	//	Запрос.УстановитьПараметр("Предприятие", Предприятие);
	//	Запрос.УстановитьПараметр("Подразделение", Подразделение);
	//	ТаблицаАссортимента = Запрос.Выполнить().Выгрузить();
	//	Для Каждого СтрокаТЧ Из ТабличнаяЧасть Цикл
	//		Если ТаблицаАссортимента.НайтиСтроки(Новый Структура("Номенклатура", СтрокаТЧ.Номенклатура)).Количество() = 0 Тогда
	//			сабОбщегоНазначенияКлиентСервер.СообщитьОбОшибке(ЭтотОбъект, "Номенклатура " + СтрокаТЧ.Номенклатура + " не входит в ассортимент", "ТабличнаяЧасть", СтрокаТЧ.НомерСтроки, "Номенклатура");
	//			ЕстьОшибки = Истина;
	//		КонецЕсли;	
	//	КонецЦикла;	
	//КонецЕсли;
	
	Если ЕстьОшибки Тогда
		Отказ = Истина;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, Режим)
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	// регистр Учетный 
	//Движения.Учетный.Записывать = Истина;
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = "ВЫБРАТЬ
	//               |	УЧ_Реализация.Ссылка КАК Ссылка
	//               |ИЗ
	//               |	Документ.УЧ_Реализация КАК УЧ_Реализация
	//               |ГДЕ
	//               |	УЧ_Реализация.ДокОснование = &ДокОснование
	//               |	И УЧ_Реализация.Проведен = ИСТИНА";
	//
	//Запрос.УстановитьПараметр("ДокОснование", Ссылка);
	//
	//Результат = Запрос.Выполнить();
	//Выборка = Результат.Выбрать();
	//
	//ЕстьПоступление = Ложь;
	//Пока Выборка.Следующий() Цикл
	//	ЕстьПоступление = Истина;
	//КонецЦикла;

	// регистр Учетный 
	Движения.Учетный.Записывать = Истина;
	//
	//Если ЕстьПоступление Тогда //оичщаем проводки
	//	Возврат;
	//КонецЕсли;
	
	СчетРезервов = ПланыСчетов.Учетный.СчетЗАК();
	УчетПоПодразделениям = СчетРезервов.УчетПоПодразделениям;
	
	Если Не ЗначениеЗаполнено(СчетРезервов) Тогда
		Возврат;	
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(Статус) ИЛИ Статус = Перечисления.СтатусыЗаказовКлиентов.Новый Или Статус = Перечисления.СтатусыЗаказовКлиентов.КОтгрузке Тогда
		Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл
			
			//заказ поставщика
			Если ВидОперации = Перечисления.ВидыЗаказов.ВозвратБрака Тогда
				Движение = Движения.Учетный.Добавить();
				Движение.СчетДт = СчетРезервов;
				Движение.Период = ДатаПоступления;
				Движение.Предприятия = Предприятие;
				Если УчетПоПодразделениям Тогда
					Движение.ПодразделениеДт = Подразделение;
				КонецЕсли;
				Движение.СценарийПлана = Справочники.СценарииПланирования.СценарийФакт();
				//Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
				Движение.КоличествоДт = ТекСтрокаТабличнаяЧасть.Количество;
				Движение.Содержание = Комментарий;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт, Движение.СчетДт, 2, ТекСтрокаТабличнаяЧасть.Склад);
			Иначе	
				Движение = Движения.Учетный.Добавить();
				Движение.СчетКт = СчетРезервов;
				Движение.Период = ДатаПоступления;
				Движение.Предприятия = Предприятие;
				Если УчетПоПодразделениям Тогда
					Движение.ПодразделениеКт = Подразделение;
				КонецЕсли;
				Движение.СценарийПлана = Справочники.СценарииПланирования.СценарийФакт();
				//Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
				Движение.КоличествоКт = ТекСтрокаТабличнаяЧасть.Количество;
				Движение.Содержание = Комментарий;
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 1, ТекСтрокаТабличнаяЧасть.Номенклатура);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт, Движение.СчетКт, 2, ТекСтрокаТабличнаяЧасть.Склад);
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") И ДанныеЗаполнения.Свойство("ВидОперации") Тогда
		ВидОперации = ДанныеЗаполнения.ВидОперации;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Статус = Перечисления.СтатусыЗаказовКлиентов.Новый;
	Для каждого строкаТ из ЭтотОбъект.ТабличнаяЧасть Цикл
		НовыйГуид = Новый УникальныйИдентификатор; 
		Для каждого строкаВ из ЭтотОбъект.ВозвратнаяТара Цикл
			НайденныеСтроки = ЭтотОбъект.ТабличнаяЧасть.НайтиСтроки(Новый Структура("ГУИДСтроки", строкаВ.ГУИДСтроки));
			СтрокаВ.ГУИДСтроки = НовыйГуид;
		КонецЦикла;
		строкаТ.ГУИДСтроки = НовыйГуид;
		//Если Не ЗначениеЗаполнено(строкаТ.ЕдиницаИзмерения) Тогда
		//	строкаТ.ЕдиницаИзмерения = строкаТ.Номенклатура.ЕдиницаИзмерения;
		//КонецЕсли;
		
		//обновление цены
		УстановитьЗависимыеДанныеВТЧ(строкаТ);
		РассчитатьСуммуТовары(строкаТ);
		
		Если Не строкаТ.КоличествоУпаковок Тогда
			строкаТ.КоличествоУпаковок = строкаТ.Количество;
		КонецЕсли;
		
	КонецЦикла;
	
	ДатаДоставки = КонецДня(ТекущаяДата()) + 1*24*60*60;
	
	Комментарий = "";
	ЗаданиеВодителю = "";
	ЗаданиеСкладу = "";
	
	Если ЗначениеЗаполнено(ПодразделениеКонтрагента) Тогда
		РеквыОбъекта = БюджетныйНаСервере.ВернутьРеквизиты(ПодразделениеКонтрагента, "Адрес, Ответственный, Ответственный.Телефон, ДатаДоставки, ДатаДоставкиДо, МаршрутДоставки"); 
		АдресДоставки = РеквыОбъекта.Адрес;
		МаршрутДоставки = РеквыОбъекта.МаршрутДоставки;
		МенеджерКонтрагента = РеквыОбъекта.Ответственный;
		Телефон = РеквыОбъекта.ОтветственныйТелефон;
		ДатаДоставки = НачалоДня(ДатаДоставки) + (РеквыОбъекта.ДатаДоставки - НачалоДня(РеквыОбъекта.ДатаДоставки));
		ДатаДоставкиДо = НачалоДня(ДатаДоставки) + (РеквыОбъекта.ДатаДоставкиДо - НачалоДня(РеквыОбъекта.ДатаДоставкиДо));  
	Иначе
		АдресДоставки = "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОтветственныеСрезПоследних.Ответственный КАК Ответственный
	|ИЗ
	|	РегистрСведений.Ответственные.СрезПоследних(&ДатаНа, Контрагент = &Контрагент) КАК ОтветственныеСрезПоследних";
	
	Запрос.УстановитьПараметр("ДатаНа", ТекущаяДата());
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Ответственный = Выборка.Ответственный;	
	КонецЦикла;
	
	//всегда берем по-умолчанию способ доставки
	ТекСпособДоставки = Справочники.сабМониторВнедрения.НайтиПоНаименованию("СпособДоставкиПоУмолчанию", Истина).Значение;
	СпособДоставки = ?(ЗначениеЗаполнено(ТекСпособДоставки), ТекСпособДоставки, СпособДоставки);
	
КонецПроцедуры


Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура РассчитатьСуммуТовары(ТекДанные = Неопределено)
	
	Если Не ТекДанные = Неопределено Тогда
		ТекДанные.Сумма = ТекДанные.Количество * ТекДанные.Цена;
		//ТекДанные.СуммаОтгрузки = ТекДанные.Количество * ТекДанные.Цена;
		
		ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.СтавкаНДС, "Ставка");
		Если НЕ ТекРеквизиты = Неопределено Тогда
			ТекДанные.СуммаНДС = ТекДанные.Сумма / ((100+ТекРеквизиты.Ставка)/100) * (ТекРеквизиты.Ставка/100);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

Процедура УстановитьЗависимыеДанныеВТЧ(ТекДанные)
	
	ЦенаКЗаполнению = РассчитатьЦену(ТекДанные.Номенклатура, Контрагент, Предприятие, Подразделение, ?(ЗначениеЗаполнено(ДатаПоступления), ДатаПоступления, ТекущаяДата()), Договор);
		ТекДанные.Цена = ЦенаКЗаполнению;
	
	//Установим НДС и артикул
	Если ЗначениеЗаполнено(ТекДанные.Номенклатура) Тогда
		ТекРеквизиты = БюджетныйНаСервере.ВернутьРеквизиты(ТекДанные.Номенклатура, "СтавкаНДС, Код, Счет10, ВидСтавкиНДС, ЕдиницаИзмерения", Ложь);
		ТекДанные.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвВидовСтавокНДСБУХУУ().Получить(ТекРеквизиты.ВидСтавкиНДС);
		Если Не ЗначениеЗаполнено(ТекДанные.ЕдиницаИзмерения) Тогда
			ТекДанные.ЕдиницаИзмерения = ТекРеквизиты.ЕдиницаИзмерения;
		КонецЕсли;
		//ТекДанные.Счет = ТекРеквизиты.Счет10;
	КонецЕсли;
	
КонецПроцедуры

Функция РассчитатьЦену(Номенклатура, Контрагент, Предприятие, Подразделение, Дата, Договор)
	
	Если Не ЗначениеЗаполнено(Договор.ТипЦен) Тогда
		Возврат 0;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Период, Номенклатура = &Номенклатура) КАК ЦеныНоменклатурыСрезПоследних
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦенНоменклатуры.ПустаяСсылка)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЦеныНоменклатурыСрезПоследних.ТипЦен = &ТипЦен
	|		КОНЕЦ";
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	//Запрос.УстановитьПараметр("Предприятие", Предприятие);
	//Запрос.УстановитьПараметр("Подразделение", Подразделение);
	Запрос.УстановитьПараметр("ТипЦен", Договор.ТипЦен);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Возврат Выборка.Цена;
	КонецЦикла;
	
	Возврат 0;
	
КонецФункции	


