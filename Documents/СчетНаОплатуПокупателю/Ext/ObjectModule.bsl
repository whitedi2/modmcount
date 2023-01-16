﻿&Перед("ОбработкаЗаполнения")
Процедура УУ_ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказКлиента") Тогда 
		
		//+lud 17/10/22 Проверка повторного создания документов из заказа по обр. №7861 от 12.10.2022 {
		Отказ = сабОперОбщегоНазначения.ПроверкаСозданияНаОснованииНаСервере(ДанныеЗаполнения, "", СтандартнаяОбработка, ТипЗнч(Ссылка));
		Если Отказ.Приказ = "##УжеСоздан" Тогда
			ВызватьИсключение "На основании заказа уже введен документ " + Отказ.Ссылка;
		ИначеЕсли Отказ.Приказ = "##НеПроведен" Тогда
			ВызватьИсключение "Документ заказ клиента не проведен. Ввод на основании не возможен.";
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Дата, Номер, ВозвратнаяТара");
		//ТекОбъект.ВидОперации = Перечисления.ВидыОперацийРеализацияТоваров.Товары;
		ЭтотОбъект.Заказ = ДанныеЗаполнения;
		ЭтотОбъект.СуммаВключаетНДС = Истина;
		ЭтотОбъект.ДокументБезНДС = Ложь;
		ЭтотОбъект.ДоговорКонтрагента = ДанныеЗаполнения.Договор;
		ЭтотОбъект.ТипЦен = ЭтотОбъект.ДоговорКонтрагента.ТипЦен;
		
		ЭтотОбъект.Товары.Очистить();
		Для каждого ТекСтрока Из ДанныеЗаполнения.ТабличнаяЧасть Цикл
			НоваяСтрока = ЭтотОбъект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
			НоваяСтрока.СтавкаНДС = сабОбщегоНазначенияБУХПовтИсп.СоотвСтавокНДСУУБУХ().Получить(ТекСтрока.СтавкаНДС);
		КонецЦикла;

	КонецЕсли; 
	
КонецПроцедуры	

&Перед("ПриЗаписи")
Процедура УУ_ПриЗаписи(Отказ)
	
	сабОбщегоНазначения.сабПлатКалПриЗаписиОбъектовПриЗаписи(ЭтотОбъект, Отказ);

КонецПроцедуры
