﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	//Если  (Субконто1 = Справочники.ИздержкиОбращения.СдельнаяЗП) или
	//	(Субконто1.Родитель = Справочники.ИздержкиОбращения.МашинныИМеханизмы) или
	//	(Субконто1.Родитель = Справочники.ИздержкиОбращения.НакладныеРасходыГруппа) Тогда
	//	СчетДт = ПланыСчетов.Учетный.Счет20();
	//Иначе
	//	СчетДт = ПланыСчетов.Учетный.Счет25();
	//КонецЕсли;
	
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

	Движения.Учетный.Записывать = Истина;
	//Если ЗначениеЗаполнено(ЮрЛицо) и ЗначениеЗаполнено(Работники) И ЗначениеЗаполнено(СчетНачисления) Тогда
	//	//проведение по новому алгоритму. 
	//	
	//	Движение = Движения.Учетный.Добавить();
	//	Движение.Период = Дата;
	//	Движение.Предприятия = Предприятие;
	//	Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
	//	
	//	Движение.СчетДт = СчетНачисления;
	//	УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетНачисления,1,Субконто1);
	//	УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетНачисления,2,Субконто2);
	//	УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,СчетНачисления,3,Субконто3);
	//	Если СчетНачисления.УчетПоПодразделениям Тогда
	//		Движение.ПодразделениеДт = КорПодразделение;
	//	КонецЕсли;
	//	
	//	Движение.СчетКт = ПланыСчетов.Учетный.Счет70();
	//	Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Сотрудники", Истина)] = Работники;
	//	//Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Организации] = ЮрЛицо;
	//	Если Движение.СчетКт.УчетПоПодразделениям Тогда
	//		Движение.ПодразделениеКт = ВидДеятельности;
	//	КонецЕсли;
	//	Движение.Сумма = ТабличнаяЧасть.Итог("Сумма");
	//	Движение.Содержание = Комментарий;
	//	
	//	Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл		 	
	//		Движение = Движения.Учетный.Добавить();
	//		Движение.Период = Дата;
	//		Движение.Предприятия = Предприятие;
	//		Движение.СценарийПлана = Справочники.СценарииПланирования.Факт;
	//		Движение.СчетДт = ПланыСчетов.Учетный.Счет70();
	//		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Сотрудники", Истина)] = Работники;
	//		//Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Организации] = ТекСтрокаТабличнаяЧасть.ЮрЛицо;
	//		
	//		Движение.СчетКт = ПланыСчетов.Учетный.Счет70();
	//		Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.НайтиПоНаименованию("Сотрудники", Истина)] = ТекСтрокаТабличнаяЧасть.Сотрудник;
	//		//Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Организации] = ТекСтрокаТабличнаяЧасть.ЮрЛицо;
	//		Если Движение.СчетКт.ВидыСубконто.Количество() > 2 Тогда
	//			//Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = ТекСтрокаТабличнаяЧасть.Подразделение;
	//		КонецЕсли;
	//		Если Движение.СчетКт.УчетПоПодразделениям Тогда
	//			Движение.ПодразделениеКт = ВидДеятельности;
	//		КонецЕсли;
	//		Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
	//		Движение.Содержание = ТекСтрокаТабличнаяЧасть.Комментарий;
	//	КонецЦикла;		
	//Иначе
		//Проведение по старому алгоритму. Чтобы не испортить старые документы
		
		СчетУчетаФизичЛиц = Предприятие.УчетнаяПолитика.СчетУчетаВыплатФизическимЛицам;
		
		Для Каждого ТекСтрокаТабличнаяЧасть Из ТабличнаяЧасть Цикл		 	
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.Предприятия = Предприятие;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.СчетДт = ТекСтрокаТабличнаяЧасть.КорСчет;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрокаТабличнаяЧасть.КорСубконто1);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,ТекСтрокаТабличнаяЧасть.КорСубконто2);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,ТекСтрокаТабличнаяЧасть.КорСубконто3);
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.КорПодразделение), ТекСтрокаТабличнаяЧасть.КорПодразделение, ТекСтрокаТабличнаяЧасть.Подразделение);
			КонецЕсли;
			
			Если ТипЗнч(ТекСтрокаТабличнаяЧасть.Сотрудник) = Тип("СправочникСсылка.Сотрудники") ИЛИ ЭтоСотрудник(ТекСтрокаТабличнаяЧасть.Сотрудник) Тогда
				Движение.СчетКт = ПланыСчетов.Учетный.Счет70();
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Сотрудник);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрокаТабличнаяЧасть.ВидНачисления);
				Если Движение.СчетКт.ВидыСубконто.Количество() > 2 Тогда
					//Движение.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконто.Подразделения] = ТекСтрокаТабличнаяЧасть.Подразделение;
				КонецЕсли;
			Иначе 
				Движение.СчетКт = ?(ЗначениеЗаполнено(СчетУчетаФизичЛиц), СчетУчетаФизичЛиц, ПланыСчетов.Учетный.Счет70());
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрокаТабличнаяЧасть.Сотрудник);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрокаТабличнаяЧасть.ВидНачисления);
			КонецЕсли;
			
			Если Движение.СчетКт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеКт = ?(ЗначениеЗаполнено(ТекСтрокаТабличнаяЧасть.КорПодразделение), ТекСтрокаТабличнаяЧасть.КорПодразделение, ТекСтрокаТабличнаяЧасть.Подразделение);
			КонецЕсли;
			Движение.Сумма = ТекСтрокаТабличнаяЧасть.Сумма;
			Движение.Содержание = ТекСтрокаТабличнаяЧасть.Комментарий;
		КонецЦикла;
	//КонецЕсли;
	
	//начисление ндфл и взносов
	МассивСтруктурНалогов = Новый Массив;
	
	СтатьяЕНС = Предприятие.УчетнаяПолитика.СтатьяСтраховыеЕНС;
	Если Не ЗначениеЗаполнено(СтатьяЕНС) Тогда
		СтатьяЕНС = Справочники.СтатьиЗатрат.НайтиПоКоду("2070.03");
	КонецЕсли;
	
	СтатьяНДФЛ = Предприятие.УчетнаяПолитика.СтатьяНДФЛ;
	Если Не ЗначениеЗаполнено(СтатьяНДФЛ) Тогда
		СтатьяНДФЛ = Справочники.СтатьиЗатрат.НайтиПоКоду("2070.04");
	КонецЕсли;

	МассивСтруктурНалогов.Добавить(Новый Структура("Сумма, СчетКт, Статья25, Содержание, Налог", "СуммаНДФЛ", ПланыСчетов.Учетный.НайтиПоКоду("68.02"), СтатьяНДФЛ, "начислен НДФЛ", Субконто_НДФЛ));
	МассивСтруктурНалогов.Добавить(Новый Структура("Сумма, СчетКт, Статья25, Содержание, Налог", "СуммаПФР", ПланыСчетов.Учетный.НайтиПоКоду("69"), СтатьяЕНС, "начислен ПФР", Субконто_ПФР));
	МассивСтруктурНалогов.Добавить(Новый Структура("Сумма, СчетКт, Статья25, Содержание, Налог", "СуммаФСС", ПланыСчетов.Учетный.НайтиПоКоду("69"), СтатьяЕНС, "начислен ФСС", Субконто_ФСС));
	МассивСтруктурНалогов.Добавить(Новый Структура("Сумма, СчетКт, Статья25, Содержание, Налог", "СуммаФССНесчСл", ПланыСчетов.Учетный.НайтиПоКоду("69"), СтатьяЕНС, "начислен ФСС (несч сл)", Субконто_ФССНесч));
	МассивСтруктурНалогов.Добавить(Новый Структура("Сумма, СчетКт, Статья25, Содержание, Налог", "СуммаФФОМС", ПланыСчетов.Учетный.НайтиПоКоду("69"), СтатьяЕНС, "начислен ФФОМС", Субконто_ФФОМС));
	МассивСтруктурНалогов.Добавить(Новый Структура("Сумма, СчетКт, Статья25, Содержание, Налог", "СуммаВзносыПоЕдиномуТарифу", ПланыСчетов.Учетный.НайтиПоКоду("69"), СтатьяЕНС, "начислено по единому тарифу", Субконто_ВзносыПоЕдиномуТарифу));
	
	ТчВрем = ТабличнаяЧасть.Выгрузить();
	ТчВрем.Колонки.Добавить("Организация");
	Для каждого ТекСтрока Из ТчВрем Цикл
		ТекСтрока.Организация = ТекСтрока.ВидНачисления.Организация;	
	КонецЦикла;
	ТчВрем.Свернуть("Организация, КорСчет, КорСубконто1, КорСубконто2, КорСубконто3, КорПодразделение, Подразделение", "Сумма, СуммаНДФЛ, СуммаПФР, СуммаФСС, СуммаФССНесчСл, СуммаФФОМС, СуммаВзносыПоЕдиномуТарифу, Удержано");
	
	Для каждого ТекНалогСтру Из МассивСтруктурНалогов Цикл
		Для каждого ТекСтрока Из ТчВрем Цикл
			
			Если НЕ ТекСтрока[ТекНалогСтру.Сумма] Тогда
				Продолжить;
			КонецЕсли;
			
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.Предприятия = Предприятие;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.СчетДт = ТекСтрока.КорСчет;
			Если ТекСтрока.КорСчет = ПланыСчетов.Учетный.НайтиПоКоду("25") ИЛИ ТекСтрока.КорСчет = ПланыСчетов.Учетный.НайтиПоКоду("26") ИЛИ ТекСтрока.КорСчет = ПланыСчетов.Учетный.НайтиПоКоду("44") Тогда
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекНалогСтру.Статья25);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,ТекСтрока.КорСубконто2);
			ИначеЕсли ТекСтрока.КорСчет = ПланыСчетов.Учетный.НайтиПоКоду("20") Тогда
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрока.КорСубконто1);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,ТекНалогСтру.Статья25);
			Иначе
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекНалогСтру.Статья25);
				УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,ТекСтрока.КорСубконто2);
			КонецЕсли;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,3,ТекСтрока.КорСубконто3);
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = ?(ЗначениеЗаполнено(ТекСтрока.КорПодразделение), ТекСтрока.КорПодразделение, ТекСтрока.Подразделение);
			КонецЕсли;
			Движение.СчетКт = ТекНалогСтру.СчетКт;
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекНалогСтру.Налог);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрока.Организация);
			//УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,3,Справочники.Сотрудники.СотрудникиОбобщенное);
			Если Движение.СчетКт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеКт = ?(ЗначениеЗаполнено(ТекСтрока.КорПодразделение), ТекСтрока.КорПодразделение, ТекСтрока.Подразделение);
			КонецЕсли;
			Движение.Сумма = ТекСтрока[ТекНалогСтру.Сумма];
			Движение.Содержание = ТекНалогСтру.Содержание;		
			
		КонецЦикла;
	КонецЦикла;
	
	//удержание
	Для каждого ТекСтрока1 Из ТабличнаяЧасть Цикл
		
		Если НЕ ТекСтрока1.Удержано Тогда
			Продолжить;
		КонецЕсли;
		
		НайденныеСтроки = Удержания.НайтиСтроки(Новый Структура("ВидНачисления, Сотрудник", ТекСтрока1.ВидНачисления, ТекСтрока1.Сотрудник));
		
		Для каждого ТекСтрока Из НайденныеСтроки Цикл
			
			Движение = Движения.Учетный.Добавить();
			Движение.Период = Дата;
			Движение.Предприятия = Предприятие;
			Движение.СценарийПлана = Справочники.СценарииПланирования.НайтиПоНаименованию("Факт", Истина);
			Движение.СчетДт = ПланыСчетов.Учетный.Счет70();
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,1,ТекСтрока1.Сотрудник);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоДт,Движение.СчетДт,2,ТекСтрока1.ВидНачисления);
			Если Движение.СчетДт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеДт = ?(ЗначениеЗаполнено(ТекСтрока1.КорПодразделение), ТекСтрока1.КорПодразделение, ТекСтрока1.Подразделение);
			КонецЕсли;
			Движение.СчетКт = ПланыСчетов.Учетный.Счет7303();
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,1,ТекСтрока.Сотрудник);
			УЧ_Сервер.УстановитьСубконто(Движение.СубконтоКт,Движение.СчетКт,2,ТекСтрока.ВидУдержания);
			Если Движение.СчетКт.УчетПоПодразделениям Тогда
				Движение.ПодразделениеКт = ?(ЗначениеЗаполнено(ТекСтрока1.КорПодразделение), ТекСтрока1.КорПодразделение, ТекСтрока1.Подразделение);
			КонецЕсли;
			Движение.Сумма = ТекСтрока.Сумма;
			
		КонецЦикла;
	КонецЦикла; 
	
	//// для строительных предприятий
	//Если Предприятие.Родитель = Справочники.Предприятия.СтроительноеНаправление Тогда
	//	
	//	Движения.Стр_ФактПоОбъекту.Записывать = Истина;
	//	Движение = Движения.Стр_ФактПоОбъекту.Добавить();
	//	Движение.Проект = Предприятие;
	//	//Движение.Проект = Предприятие;
	//	
	//КонецЕсли;
	
КонецПроцедуры

Функция ЭтоСотрудник(ФизЛицо)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник
		|ИЗ
		|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
		|ГДЕ
		|	ТекущиеКадровыеДанныеСотрудников.ФизическоеЛицо.Ссылка = &ФизЛицо";
	
	Запрос.УстановитьПараметр("ФизЛицо", ФизЛицо);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат Истина;
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	//Если НЕ ЮрЛицо.Пустая() Тогда
	//Для каждого ТекСтрока Из ТабличнаяЧасть Цикл
	//	Если ЗначениеЗаполнено(ЮрЛицо) Тогда
	//		ТекСтрока.ЮрЛицо = ЮрЛицо;		           		
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(ЮрЛицо) Тогда
	//		ТекСтрока.ЮрЛицо = ЮрЛицо;		           		
	//	КонецЕсли;
	//КонецЦикла; 
	//КонецЕсли;
	СуммаДокумента = ТабличнаяЧасть.Итог("Сумма");
	
	//из подписки на событие
	БюджетныйНаСервере.ДокументыПередЗаписьюПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	//Для Каждого Стр Из ТабличнаяЧасть Цикл
	//	Стр.ЮрЛицо = Справочники.ЮрЛицаДляСотрудников.ПустаяСсылка();
	//КонецЦикла;
	
	РучнаяКорректировка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	РучнаяКорректировка = Ложь;
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	БюджетныйНаСервере.ПриУстановкеНовогоНомераПриУстановкеНовогоНомера(ЭтотОбъект, СтандартнаяОбработка, Префикс);
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	сабОбщегоНазначенияБУХ.сабОбработкиЗаполненияУчпетныхДокументовОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

Процедура ОбработкаЗаполненияСФормы(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт

	ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);	

КонецПроцедуры
