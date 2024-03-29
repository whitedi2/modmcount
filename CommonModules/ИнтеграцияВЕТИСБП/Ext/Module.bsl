﻿
&Вместо("ЗаполнениеДокументовВЕТИС")
Процедура УУ_ЗаполнениеДокументовВЕТИС(ДокументОбъект, Знач ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)

	Если НЕ ЗначениеЗаполнено(ДанныеЗаполнения) Тогда
		Возврат;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		Если ДанныеЗаполнения.Свойство("Основание") Тогда
			ДанныеЗаполнения = ДанныеЗаполнения.Основание;
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
		
	Если ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ИнвентаризацияПродукцииВЕТИС") Тогда
		//Основания СписаниеТоваров, ОприходованиеТоваров
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация, Склад, Номер, Дата");
		Грузоотправитель = Справочники.ХозяйствующиеСубъектыВЕТИС.ХозяйствующийСубъектИПредприятиеПоПрикладнымРеквизитам(РеквизитыОснования.Организация, РеквизитыОснования.Склад);
		ДокументОбъект.ХозяйствующийСубъект    = Грузоотправитель.ХозяйствующийСубъект;
		ДокументОбъект.Предприятие             = Грузоотправитель.Предприятие;
		ДокументОбъект.ТорговыйОбъект          = РеквизитыОснования.Склад;
		ДокументОбъект.НомерАктаНесоответствия = РеквизитыОснования.Номер;
		ДокументОбъект.ДатаАктаНесоответствия  = РеквизитыОснования.Дата;
		ДокументОбъект.ДокументОснование       = ДанныеЗаполнения;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОприходованиеТоваров") Тогда
			ЗаполнитьТоварыВЕТИСОприходование(ДокументОбъект, ДанныеЗаполнения);
		ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СписаниеТоваров") Тогда
			ЗаполнитьТоварыВЕТИССписание(ДокументОбъект, ДанныеЗаполнения);
		Иначе
			ЗаполнитьТоварыВЕТИС(ДокументОбъект, ДанныеЗаполнения);
		КонецЕсли;
		
		ДокументОбъект.УпаковкиВЕТИС.Очистить();
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ИсходящаяТранспортнаяОперацияВЕТИС") Тогда
		//Основания ВозвратТоваровПоставщику, РеализацияТоваровУслуг, ПеремещениеТоваров
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
			РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация, СкладОтправитель, СкладПолучатель, Номер, Дата");
			Грузоотправитель = Справочники.ХозяйствующиеСубъектыВЕТИС.ХозяйствующийСубъектИПредприятиеПоПрикладнымРеквизитам(РеквизитыОснования.Организация, РеквизитыОснования.СкладОтправитель);
			Грузополучатель = Справочники.ХозяйствующиеСубъектыВЕТИС.ХозяйствующийСубъектИПредприятиеПоПрикладнымРеквизитам(РеквизитыОснования.Организация, РеквизитыОснования.СкладПолучатель);
		Иначе
			РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация, Склад, Контрагент, Номер, Дата");
			Грузоотправитель = Справочники.ХозяйствующиеСубъектыВЕТИС.ХозяйствующийСубъектИПредприятиеПоПрикладнымРеквизитам(РеквизитыОснования.Организация, РеквизитыОснования.Склад);
			Грузополучатель = Справочники.ХозяйствующиеСубъектыВЕТИС.ХозяйствующийСубъектИПредприятиеПоПрикладнымРеквизитам(РеквизитыОснования.Контрагент, Справочники.Склады.ПустаяСсылка());
		КонецЕсли; 
		
		ДокументОбъект.ГрузоотправительХозяйствующийСубъект = Грузоотправитель.ХозяйствующийСубъект;
		ДокументОбъект.ГрузоотправительПредприятие          = Грузоотправитель.Предприятие;
		ДокументОбъект.ГрузополучательХозяйствующийСубъект  = Грузополучатель.ХозяйствующийСубъект;
		ДокументОбъект.ГрузополучательПредприятие           = ПолучитьПредприятиеГрузополучателя(ДокументОбъект, Грузополучатель);
		ДокументОбъект.НомерТТН                             = РеквизитыОснования.Номер;
		ДокументОбъект.ДатаТТН                              = РеквизитыОснования.Дата;
		ДокументОбъект.ДокументОснование                    = ДанныеЗаполнения;
				
		ЗаполнитьТоварыВЕТИС(ДокументОбъект, ДанныеЗаполнения);
		ДокументОбъект.УпаковкиВЕТИС.Очистить();
		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ВходящаяТранспортнаяОперацияВЕТИС") Тогда
		ДокументОбъект.ДокументОснование = ДанныеЗаполнения;

		
	ИначеЕсли ТипЗнч(ДокументОбъект) = Тип("ДокументОбъект.ПроизводственнаяОперацияВЕТИС") Тогда
		//Основание ОтчетПроизводстваЗаСмену
		РеквизитыОснования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация, Склад, ПодразделениеЗатрат, Номер, Дата");
		Грузоотправитель = Справочники.ХозяйствующиеСубъектыВЕТИС.ХозяйствующийСубъектИПредприятиеПоПрикладнымРеквизитам(РеквизитыОснования.Организация, РеквизитыОснования.ПодразделениеЗатрат);
		ДокументОбъект.ХозяйствующийСубъект = Грузоотправитель.ХозяйствующийСубъект;
		ДокументОбъект.Предприятие          = Грузоотправитель.Предприятие;
		ДокументОбъект.ДокументОснование    = ДанныеЗаполнения;
		
		Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ОтчетПроизводстваЗаСмену") Тогда
			ЗаполнитьСырьеПродукцию(ДокументОбъект, ДанныеЗаполнения);
		Иначе
			ЗаполнитьСырье(ДокументОбъект, ДанныеЗаполнения);
		КонецЕсли;
		ДокументОбъект.УпаковкиВЕТИС.Очистить();
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Ответственный", ДокументОбъект.Метаданные()) Тогда
		ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьПредприятиеГрузополучателя(ДокументОбъект, Грузополучатель)
	
	ПредприятиеГрузополучателя = Грузополучатель.Предприятие; 
	
	Если Не ЗначениеЗаполнено(ПредприятиеГрузополучателя) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		Если ТипЗнч(ДокументОбъект.ДокументОснование) = Тип("ДокументСсылка.РеализацияТоваровУслуг") И ЗначениеЗаполнено(ДокументОбъект.ДокументОснование.Заказ) И ЗначениеЗаполнено(ДокументОбъект.ДокументОснование.Заказ.ПодразделениеКонтрагента) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	сабСоответствиеПредприятийВетис.Предприятие КАК Предприятие
			|ИЗ
			|	РегистрСведений.сабСоответствиеПредприятийВетис КАК сабСоответствиеПредприятийВетис
			|ГДЕ
			|	сабСоответствиеПредприятийВетис.ПодразделениеКонтрагента = &ПодразделениеКонтрагента";
			
			Запрос.УстановитьПараметр("ПодразделениеКонтрагента", ДокументОбъект.ДокументОснование.Заказ.ПодразделениеКонтрагента);
			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			Пока Выборка.Следующий() Цикл 
				
				Если ЗначениеЗаполнено(Грузополучатель.ХозяйствующийСубъект) И Грузополучатель.ХозяйствующийСубъект.Контрагент = ДокументОбъект.ДокументОснование.Контрагент Тогда
					ПредприятиеГрузополучателя = Выборка.Предприятие;			
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
	Возврат ПредприятиеГрузополучателя;
	
КонецФункции
